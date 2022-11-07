// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target {
	static func utilsKit() -> Target {
#if canImport(UIKit)
		return .target(
			name: "UtilsKit",
			dependencies: [],
			path: ".",
			sources: ["UtilsKit/Helpers", "UtilsKit/UI"])
#else
		return .target(
			name: "UtilsKit",
			dependencies: [],
			path: ".",
			sources: ["UtilsKit/Helpers"])
#endif
	}
}

let package = Package(
	name: "UtilsKit",
	platforms: [.iOS("12.0"), .macOS("13.0")],
	products: [
		.library(
			name: "UtilsKit",
			type: .dynamic,
			targets: ["UtilsKit"]),
	],
	targets: [.utilsKit()]
)
