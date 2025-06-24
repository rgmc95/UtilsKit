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
			name: "UtilsKitHelpers",
			targets: ["UtilsKitHelpers"]),
		.library(
			name: "UtilsKitMap",
			targets: ["UtilsKitMap"]),
		.library(
			name: "UtilsKitUI",
			targets: ["UtilsKitUI"]),
		.library(
			name: "UtilsKitUIKit",
			targets: ["UtilsKitUIKit"]),
		.library(
			name: "UtilsKitSwiftUI",
			targets: ["UtilsKitSwiftUI"]),
	],
	targets: [.target(
				name: "UtilsKitCore",
				dependencies: []),
			  .target(
				name: "UtilsKitHelpers",
				dependencies: ["UtilsKitCore"]),
			  .target(
				name: "UtilsKitMap",
				dependencies: ["UtilsKitHelpers"]),
			  .target(
				name: "UtilsKitUI",
				dependencies: ["UtilsKitHelpers"]),
			  .target(
				name: "UtilsKitUIKit",
				dependencies: ["UtilsKitUI"]),
			  .target(
				name: "UtilsKitSwiftUI",
				dependencies: ["UtilsKitUI"])
	]
)
