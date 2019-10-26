import Foundation
import JavaScriptCore

/// Provides utility functionality backed by JavaScript.
internal class JavaScriptUtils {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public static let address = "address"
    public static let decodeXAddress = "decodeXAddress"
    public static let encodeXAddress = "encodeXAddress"
    public static let isValidAddress = "isValidAddress"
    public static let isValidClassicAddress = "isValidClassicAddress"
    public static let isValidXAddress = "isValidXAddress"
    public static let tag = "tag"
    public static let utils = "Utils"
  }

  /// Native javaScript functions wrapped by this class.
  private let encodeXAddressFunction: JSValue
  private let decodeXAddressFunction: JSValue
  private let isValidAddressFunction: JSValue
  private let isValidClassicAddressFunction: JSValue
  private let isValidXAddressFunction: JSValue

  /// Initialize a JavaScriptUtils object.
  public init() {
    let context = XRPJavaScriptLoader.XRPJavaScriptContext

    let utils = XRPJavaScriptLoader.load(ResourceNames.utils, from: context)
    encodeXAddressFunction = XRPJavaScriptLoader.load(ResourceNames.encodeXAddress, from: utils)
    decodeXAddressFunction = XRPJavaScriptLoader.load(ResourceNames.decodeXAddress, from: utils)
    isValidAddressFunction = XRPJavaScriptLoader.load(ResourceNames.isValidAddress, from: utils)
    isValidClassicAddressFunction = XRPJavaScriptLoader.load(ResourceNames.isValidClassicAddress, from: utils)
    isValidXAddressFunction = XRPJavaScriptLoader.load(ResourceNames.isValidXAddress, from: utils)
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

  /// Validate if the given string is a valid X-address on the XRP Ledger.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter address: An address to check.
  /// - Returns true if the address is a valid X-address, otherwise false.
  public func isValidXAddress(address: Address) -> Bool {
    let result = isValidXAddressFunction.call(withArguments: [ address ])!
    return result.toBool()
  }

  /// Validate if the given string is a valid  classic address on the XRP Ledger.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter address: An address to check.
  /// - Returns true if the address is a valid classic address, otherwise false.
  public func isValidClassicAddress(address: Address) -> Bool {
    let result = isValidClassicAddressFunction.call(withArguments: [ address ])!
    return result.toBool()
  }

  /// Encode the given classic address and tag into an X-Qddress.
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
  /// - Parameter xAddress: The X-Address to decode.
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
