// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "Timer",
    platforms: [
        .iOS(.v16)   // UI/Platform用。CoreはどのOSでもOK
    ],
    products: [
        .library(name: "TimerCore", targets: ["TimerCore"]),
        .library(name: "TimerPlatform", targets: ["TimerPlatform"]),
        .library(name: "TimerUI", targets: ["TimerUI"]),
    ],
    targets: [
        // 1) プラットフォーム非依存ロジック（Windowsでビルド＆テスト）
        .target(name: "TimerCore",
                path: "Sources/TimerCore"),
        .testTarget(name: "TimerCoreTests",
                    dependencies: ["TimerCore"],
                    path: "Tests/TimerCoreTests"),

        // 2) iOS専用機能（通知）。WindowsはStubsで空実装
        .target(name: "TimerPlatform",
                path: "Sources/TimerPlatform",
                sources: ["iOS", "Stubs"]),

        // 3) SwiftUIビュー（Appleプラットフォームで利用）
        .target(name: "TimerUI",
                dependencies: ["TimerCore", "TimerPlatform"],
                path: "Sources/TimerUI")
    ]
)
