// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Caddie",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Caddie",
            targets: ["Caddie"]),
    ],
    dependencies: [
        // Dependencies here
    ],
    targets: [
        .target(
            name: "Caddie",
            dependencies: [],
            path: "Sources"
        )
    ]
) 