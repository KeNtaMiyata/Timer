// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "shared",
    products: [
        .library(name: "TimerCore", targets: ["TimerCore"]),
        .executable(name: "TimerCLI", targets: ["TimerCLI"]),
    ],
    targets: [
        .target(name: "TimerCore"),
        .executableTarget(name: "TimerCLI", dependencies: ["TimerCore"]),
        .testTarget(name: "TimerCoreTests", dependencies: ["TimerCore"]),
    ]
)
