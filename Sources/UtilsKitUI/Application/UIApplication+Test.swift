//
//  UIApplication+Test.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import UIKit

@available(iOSApplicationExtension, introduced: 1.0, unavailable)
extension UIApplication {
	
	/// A Boolean value that indicates whether the app is currently running a UI test.
	///
	/// This property checks the launch arguments passed to the app's process to determine if it includes the `"UITest"` flag.
	/// If the `"UITest"` argument is present, the property returns `true`, indicating that the app is being run in the context of a UI test.
	///
	/// - Returns: `true` if the app is running a UI test; otherwise, `false`.
	///
	/// ### Example
	/// ```swift
	/// if UIApplication.shared.isRunningUITest {
	///     // Perform actions specific to UI testing.
	///     print("App is running a UI test.")
	/// }
	/// ```
	///
	/// ### Usage in UI Tests
	/// In your UI test target, you can add the launch argument when starting the app:
	/// ```swift
	/// let app = XCUIApplication()
	/// app.launchArguments.append("UITest")
	/// app.launch()
	/// ```
	///
	/// ### Notes
	/// - This property uses `ProcessInfo.processInfo.arguments` to check for the presence of the `"UITest"` argument.
	/// - The `@available` attribute ensures that this extension is not available in app extensions, as `UIApplication` is unavailable in such contexts.
	public var isRunningUITest: Bool {
		ProcessInfo.processInfo.arguments.contains("UITest")
	}
}
