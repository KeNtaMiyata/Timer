// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "Timer",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "TimerCore", targets: ["TimerCore"])
    ],
    targets: [
        .target(name: "TimerCore"),
        .testTarget(name: "TimerCoreTests", dependencies: ["TimerCore"])
    ]
)