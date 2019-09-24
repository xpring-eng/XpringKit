import Foundation
import JavaScriptCore

/// Provides utility functionality backed by JavaScript.
internal class JavaScriptUtils {
	/// String constants which refer to named JavaScript resources.
	private enum ResourceNames {
		public static let isValidAddress = "isValidAddress"
		public static let utils = "Utils"
	}

	/// Native javaScript functions wrapped by this class.
	private let isValidAddressFunction: JSValue

	/// Initialize a JavaScriptUtils object.
	public init() {
		let context = XRPJavaScriptLoader.XRPJavaScriptContext
		let utils = XRPJavaScriptLoader.load(ResourceNames.utils, from: context)
		isValidAddressFunction = XRPJavaScriptLoader.load(ResourceNames.isValidAddress, from: utils)
	}

	/// Check if the given address is a valid XRP address.
	///
	/// - Note: This function only checks that the address is a valid address, the activation status of the address on the ledger is not checked by this function.
	///
	/// - Parameter address: The address to validate.
	///	- Returns: true if the address is valid, otherwise false.
	public func isValid(address: Address) -> Bool {
		let result = isValidAddressFunction.call(withArguments: [ address ])!
		return result.toBool()
	}
}
