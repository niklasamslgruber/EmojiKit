// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EmojiKit",
    platforms: [.macOS(.v13), .iOS(.v15), .watchOS(.v8), .tvOS(.v15)],
    products: [
        .library(
            name: "EmojiKit",
            targets: ["EmojiKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
    ],
    targets: [
        .executableTarget(
            name: "EmojiSourceKit",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                .target(name: "EmojiKit")
            ]),
        .target(
            name: "EmojiKit", resources: [
                .process("Resources")
        ])
    ]
)
