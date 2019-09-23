/// Provides utility functions for working in the XRP Ecosystem.
public enum Utils {
	/// The underlying JavaScript based utilities.
	private static let javaScriptUtils = JavaScriptUtils()

	/// Check if the given address is a valid XRP address.
	///
	/// - Note: This function only checks that the address is a valid address, the activation status of the address on the ledger is not checked by this function.
	///
	/// - Parameter address: The address to validate.
	///	- Returns: true if the address is valid, otherwise false.
	public static func isValid(address: Address) -> Bool {
		return javaScriptUtils.isValid(address: address)
	}
}
