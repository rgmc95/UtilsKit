// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UtilsKit",
    platforms: [.iOS("10.0")],
    products: [
        .library(
            name: "UtilsKit",
            type: .dynamic,
            targets: ["UtilsKit"]),
    ],
    targets: [
        .target(
            name: "UtilsKit",
            dependencies: [],
            path: ".",
            sources: ["UtilsKit/Helpers", "UtilsKit/UI"]),
    ]
)
