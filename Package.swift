// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "RunnerToolchain",
    products: [.library(name: "RunnerToolchain", targets: ["RunnerToolchain"])],
    targets: [
        .target(name: "RunnerToolchain"),
        .testTarget(name: "RunnerToolchainTests", dependencies: ["RunnerToolchain"])
    ]
)
