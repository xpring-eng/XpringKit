import Foundation
import JavaScriptCore

/// Provides utility functionality backed by JavaScript.
internal class JavaScriptUtils {
	/// String constants which refer to named JavaScript resources.
	private enum ResourceNames {
    public static let address = "address"
    public static let tag = "tag"
    public static let isValidAddress = "isValidAddress"
    public static let decodeXAddress = "decodeXAddress"
    public static let encodeXAddress = "encodeXAddress"
    public static let utils = "Utils"
	}

	/// Native javaScript functions wrapped by this class.
	private let isValidAddressFunction: JSValue
    private let encodeXAddressFunction: JSValue
    private let decodeXAddressFunction: JSValue

	/// Initialize a JavaScriptUtils object.
	public init() {
		let context = XRPJavaScriptLoader.XRPJavaScriptContext

		let utils = XRPJavaScriptLoader.load(ResourceNames.utils, from: context)

        isValidAddressFunction = XRPJavaScriptLoader.load(ResourceNames.isValidAddress, from: utils)
        encodeXAddressFunction = XRPJavaScriptLoader.load(ResourceNames.encodeXAddress, from: utils)
        decodeXAddressFunction = XRPJavaScriptLoader.load(ResourceNames.decodeXAddress, from: utils)
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

    /// Encode the given classic address and tag into an x-address.
    ///
    /// - SeeAlso: https://xrpaddress.info/
    ///
    /// - Parameters:
    ///   -  classicAddress: A classic address to encode.
    ///   - tag: An optional tag to encode. Defaults to nil.
    /// - Returns: A new x-address if inputs were valid, otherwise undefined.
    public func encode(classicAddress: Address, tag: UInt32? = nil) -> Address? {
      var arguments: [Any] = [ classicAddress ]
      if tag != nil {
        arguments.append(tag as Any)
      }

      let result = encodeXAddressFunction.call(withArguments: arguments)!
      return result.isUndefined ? nil : result.toString()
    }

    /// Decode a classic address from a given x-address.
    ///
    /// - SeeAlso: https://xrpaddress.info/
    ///
    /// - Parameter xAddress: The xAddress to decode.
    /// - Returns: a tuple containing the decoded address and tag.
    public func decode(xAddress: Address) -> (classicAddress: String, tag: UInt32?)? {
      let result = decodeXAddressFunction.call(withArguments: [ xAddress ])!
      guard !result.isUndefined else {
        return nil
      }

      let classicAddress = XRPJavaScriptLoader.load(ResourceNames.address, from: result).toString()!
      if let tag = XRPJavaScriptLoader.failableLoad(ResourceNames.tag, from: result) {
        return (classicAddress, tag.toUInt32())
      }
      return (classicAddress, nil)
    }
}
