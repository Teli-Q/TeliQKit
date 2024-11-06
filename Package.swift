// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "TeliQKit",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "TeliQKit",
            targets: ["TeliQKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TeliQKit"),
        .testTarget(
            name: "TeliQKitTests",
            dependencies: ["TeliQKit"]
        ),
    ]
)
