// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TSKit.Storage",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "TSKit.Storage",
            targets: ["TSKit.Storage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/adya/TSKit.Core.git", .upToNextMajor(from: "2.12.0")),
    ],
    targets: [
        .target(
            name: "TSKit.Storage",
            dependencies: ["TSKit.Core"]),
        .testTarget(
            name: "TSKit.StorageTests",
            dependencies: ["TSKit.Storage"]),
    ]
)
