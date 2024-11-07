// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "TeliQKit",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "TeliQKit",
            targets: ["TeliQKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6")
    ],
    targets: [
        .target(
            name: "TeliQKit",
            dependencies: ["Starscream"]),
        .testTarget(
            name: "TeliQKitTests",
            dependencies: ["TeliQKit"]
        ),
    ]
)
