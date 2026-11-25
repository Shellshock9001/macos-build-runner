#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p out
xcrun simctl list devices available --json > out/devices.json
DEVICE="$(python3 - <<'PY'
import json
data = json.load(open("out/devices.json"))["devices"]
def version(key):
    return tuple(int(x) for x in key.split("iOS-")[-1].split("-") if x.isdigit())
for key in sorted((k for k in data if ".iOS-" in k), key=version, reverse=True):
    for device in data[key]:
        if device.get("isAvailable") and device["name"].startswith("iPhone") and device["state"] == "Shutdown":
            print(device["udid"])
            raise SystemExit(0)
raise SystemExit("No available shutdown iPhone simulator")
PY
)"
cleanup() {
  xcrun simctl shutdown "$DEVICE" >/dev/null 2>&1 || true
}
trap cleanup EXIT
echo "Selected simulator: $DEVICE"
xcodebuild -project smoke/RunnerProbe.xcodeproj -target RunnerProbe -configuration Debug -sdk iphonesimulator ARCHS=arm64 ONLY_ACTIVE_ARCH=NO CODE_SIGNING_ALLOWED=NO CONFIGURATION_BUILD_DIR="$PWD/out/build" build 2>&1 | tee out/xcodebuild.log
APP="$PWD/out/build/RunnerProbe.app"
test -x "$APP/RunnerProbe"
# Simulator apps do not require an Apple developer account; sign locally ad hoc.
codesign --force --sign - "$APP"
codesign --verify --strict "$APP"
xcrun simctl boot "$DEVICE"
xcrun simctl bootstatus "$DEVICE" -b
xcrun simctl install "$DEVICE" "$APP"
xcrun simctl launch "$DEVICE" org.macosrunner.probe | tee out/launch.txt
grep -Eq 'org\.macosrunner\.probe: [0-9]+' out/launch.txt
sleep 3
xcrun simctl io "$DEVICE" screenshot out/simulator.png
test -s out/simulator.png
python3 - "$DEVICE" <<'PY'
import hashlib, json, pathlib, re, struct, sys
p = pathlib.Path("out/simulator.png")
b = p.read_bytes()
assert b[:8] == b"\x89PNG\r\n\x1a\n" and b[12:16] == b"IHDR", "Invalid screenshot"
w, h = struct.unpack(">II", b[16:24])
assert w > 0 and h > 0
launch = pathlib.Path("out/launch.txt").read_text()
pid = int(re.search(r"org\.macosrunner\.probe: (\d+)", launch).group(1))
result = {"simulator": sys.argv[1], "bundle": "org.macosrunner.probe", "launch_pid": pid, "screenshot": {"sha256": hashlib.sha256(b).hexdigest(), "width": w, "height": h}, "app_compiled": True, "app_installed": True, "app_launched": True}
pathlib.Path("out/result.json").write_text(json.dumps(result, indent=2)+"\n")
print(json.dumps(result, indent=2))
PY
