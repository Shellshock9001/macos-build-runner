#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p out
{
  sw_vers
  uname -m
  xcode-select -p
  xcodebuild -version
  swift --version
  xcodebuild -showsdks
  xcrun --sdk iphoneos --show-sdk-path
  xcrun --sdk iphonesimulator --show-sdk-path
} | tee out/toolchain.txt
test "$(uname -s)" = Darwin
test "$(uname -m)" = arm64
xcrun simctl list runtimes --json > out/runtimes.json
xcrun simctl list devices available --json > out/devices.json
python3 - <<'PY'
import json
runtimes = json.load(open("out/runtimes.json"))["runtimes"]
available = [r["identifier"] for r in runtimes if r.get("isAvailable") and r["identifier"].startswith("com.apple.CoreSimulator.SimRuntime.iOS-")]
assert available, "No available iOS simulator runtime"
print("Available iOS runtimes:", ", ".join(available))
PY
