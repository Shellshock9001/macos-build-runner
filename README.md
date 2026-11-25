# macOS Build Runner

Standalone Apple Silicon macOS CI qualification tools. This repository contains only its own public runner utilities and an independent minimal SwiftUI smoke-test app.

## What is verified

- Actual macOS and ARM64 host identity, Xcode and Swift versions, installed SDKs and simulator runtimes.
- Swift package compilation and unit tests.
- Native SwiftUI simulator application compilation using Xcode.
- Selection and boot of an installed iPhone simulator, installation and launch of the test application, screenshot capture, and cleanup.
- Public, non-sensitive diagnostics and a screenshot of the sample app.

The CI workflow runs on the standard `macos-15` Apple Silicon hosted runner. The runner is temporary, not a persistent macOS server.

## Run

Use **Actions → macOS runner qualification → Run workflow**, or push a change to the default branch. The workflow uses no external credentials or private repository checkout.

On an Apple Silicon Mac with Xcode, an installed iOS simulator runtime and Python 3:

```sh
bash scripts/verify-xcode.sh
swift test
bash scripts/verify-simulator.sh
```

Outputs are saved to `out/` (ignored by Git). The Actions artifact contains toolchain metadata, compilation logs and the independent sample screenshot. All files and logs in this public repository may be visible to others. Do not submit proprietary source, private build artifacts, credentials, device records or customer data here.

## Scope

This repository tests its own tooling and sample application. It is not an arbitrary remote execution service, a commercial simulator host, a way to evade private-repository billing, or a signing/deployment service. Any future private build should execute within the authorized private repository or a separately provisioned Mac host. Reusable workflows are billed to the caller.

References: [GitHub-hosted runners](https://docs.github.com/en/actions/reference/runners/github-hosted-runners), [runner images](https://github.com/actions/runner-images), [Xcode](https://developer.apple.com/xcode/).
