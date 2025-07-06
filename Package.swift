// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UtilsKit",
	platforms: [.iOS("16.0"), .macOS("14.0")],
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
