// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "propellr",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "propellr",
            targets: ["propellr"]),
    ],
    dependencies: [
        .package(url: "https://github.com/basiqio/basiq-ios-sdk.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "propellr",
            dependencies: [
                .product(name: "Basiq", package: "basiq-ios-sdk")
            ],
            path: "Sources"
        )
    ]
) 