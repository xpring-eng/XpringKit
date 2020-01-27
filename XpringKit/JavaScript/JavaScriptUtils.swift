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
    public static let test = "test"
    public static let transactionBlobToTransactionHash = "transactionBlobToTransactionHash"
    public static let utils = "Utils"
  }

  /// The JavaScript class.
  private let utils: JSValue

  /// Native JavaScript functions wrapped by this class.
  // TODO(keefertaylor): This class should use the same pattern as JSWallet, where `invokeMethod` is called on a class object and direct function references are not kept. 
  private let encodeXAddressFunction: JSValue
  private let decodeXAddressFunction: JSValue
  private let isValidAddressFunction: JSValue
  private let isValidClassicAddressFunction: JSValue
  private let isValidXAddressFunction: JSValue

  /// Initialize a JavaScriptUtils object.
  public init() {
    let context = XRPJavaScriptLoader.XRPJavaScriptContext

    utils = XRPJavaScriptLoader.load(ResourceNames.utils, from: context)
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
  ///   - isTest Whether the address is for use on a test network, defaults to `false`.
  /// - Returns: A new X-address if inputs were valid, otherwise undefined.
  public func encode(classicAddress: Address, tag: UInt32? = nil, isTest: Bool = false) -> Address? {
    var arguments: [Any] = [ classicAddress ]
    if tag != nil {
      arguments.append(tag as Any)
    }
    arguments.append(isTest)

    let result = encodeXAddressFunction.call(withArguments: arguments)!
    return result.isUndefined ? nil : result.toString()
  }

  /// Decode a classic address from a given X-address.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter xAddress: The X-Address to decode.
  /// - Returns: a tuple containing the decoded address,  tag and bool indicating if the address was on a test network.
  public func decode(xAddress: Address) -> (classicAddress: String, tag: UInt32?, isTest: Bool)? {
    let result = decodeXAddressFunction.call(withArguments: [ xAddress ])!
    guard !result.isUndefined else {
      return nil
    }

    let classicAddress = XRPJavaScriptLoader.load(ResourceNames.address, from: result).toString()!
    let isTest = XRPJavaScriptLoader.load(ResourceNames.test, from: result).toBool()
    if let tag = XRPJavaScriptLoader.failableLoad(ResourceNames.tag, from: result) {
      return (classicAddress, tag.toUInt32(), isTest)
    }
    return (classicAddress, nil, isTest)
  }

  /// Convert the given transaction blob to a transaction hash.
  ///
  /// - Parameter transactionBlobHex: A hexadecimal encoded transaction blob.
  /// - Returns: A hex encoded hash if the input was valid, otherwise undefined.
  public func toTransactionHash(transactionBlobHex: Hex) -> Hex? {
    let result = utils.invokeMethod(ResourceNames.transactionBlobToTransactionHash, withArguments: [transactionBlobHex])!
    guard !result.isUndefined else {
      return nil
    }
    return result.toString()
  }
}
