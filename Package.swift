// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EBRxTimer",
    products: [
        .library(
            name: "EBRxTimer",
            type: .dynamic,
            targets: ["EBRxTimer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.0.0-rc.2"))
    ],
    targets: [
        .target(
            name: "EBRxTimer",
            dependencies: [
                "RxSwift"
            ]),
        .testTarget(
            name: "EBRxTimerTests",
            dependencies: ["EBRxTimer"]),
    ]
)
