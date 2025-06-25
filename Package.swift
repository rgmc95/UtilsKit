// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UtilsKit",
	platforms: [.iOS("14.0"), .macOS("13.0")],
	products: [
		.library(
			name: "UtilsKitCore",
			targets: ["UtilsKitCore"]),
		.library(
			name: "UtilsKitMap",
			targets: ["UtilsKitMap"]),
		.library(
			name: "UtilsKitUI",
			targets: ["UtilsKitUI"]),
	],
	targets: [.target(
				name: "UtilsKitCore",
				dependencies: []),
			  .target(
				name: "UtilsKitMap",
				dependencies: ["UtilsKitCore"]),
			  .target(
				name: "UtilsKitUI",
				dependencies: ["UtilsKitCore"]),
	]
)
