// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UtilsKit",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "UtilsKit",
            targets: ["UtilsKit"]),
        .library(
            name: "CoreDataKit",
            targets: ["CoreData"]),
        .library(
            name: "NetworkKit",
            targets: ["Network"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "UtilsKit",
            dependencies: [],
            path: ".",
            sources: ["UtilsKit/Helpers", "UtilsKit/UI"]),
        .target(
            name: "CoreData",
            dependencies: ["UtilsKit"],
            path: ".",
            sources: ["UtilsKit/CoreData"]),
        .target(
            name: "Network",
            dependencies: ["UtilsKit"],
            path: ".",
            sources: ["UtilsKit/Network"]),
    ]
)