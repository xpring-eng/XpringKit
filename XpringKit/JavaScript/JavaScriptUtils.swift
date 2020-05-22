import Foundation
import JavaScriptCore

/// Provides utility functionality backed by JavaScript.
internal class JavaScriptUtils {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public enum Classes {
      public static let utils = "Utils"
    }

    public enum Methods {
      public static let decodeXAddress = "decodeXAddress"
      public static let encodeXAddress = "encodeXAddress"
      public static let isValidAddress = "isValidAddress"
      public static let isValidClassicAddress = "isValidClassicAddress"
      public static let isValidXAddress = "isValidXAddress"
      public static let transactionBlobToTransactionHash = "transactionBlobToTransactionHash"
    }

    public enum Properties {
      public static let address = "address"
      public static let tag = "tag"
      public static let test = "test"
    }
  }

  /// The JavaScript class.
  private let utilsClass: JSValue

  /// Initialize a JavaScriptUtils object.
  public init() {
    utilsClass = JavaScriptLoader.load(ResourceNames.Classes.utils)
  }

  /// Check if the given address is a valid XRP address.
  ///
  /// - Note: This function only checks that the address is a valid address, the activation status of the address on the
  ///         ledger is not checked by this function.
  ///
  /// - Parameter address: The address to validate.
  ///	- Returns: true if the address is valid, otherwise false.
  public func isValid(address: XRPAddress) -> Bool {
    let result = utilsClass.invokeMethod(ResourceNames.Methods.isValidAddress, withArguments: [ address ])!
    return result.toBool()
  }

  /// Validate if the given string is a valid X-address on the XRP Ledger.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter address: An address to check.
  /// - Returns true if the address is a valid X-address, otherwise false.
  public func isValidXAddress(address: XRPAddress) -> Bool {
    let result = utilsClass.invokeMethod(ResourceNames.Methods.isValidXAddress, withArguments: [ address ])!
    return result.toBool()
  }

  /// Validate if the given string is a valid  classic address on the XRP Ledger.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter address: An address to check.
  /// - Returns true if the address is a valid classic address, otherwise false.
  public func isValidClassicAddress(address: XRPAddress) -> Bool {
    let result = utilsClass.invokeMethod(ResourceNames.Methods.isValidClassicAddress, withArguments: [ address ])!
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
  public func encode(classicAddress: XRPAddress, tag: UInt32? = nil, isTest: Bool = false) -> XRPAddress? {
    var arguments: [Any?] = [ classicAddress ]
    if tag != nil {
      arguments.append(tag as Any)
    } else {
      arguments.append(JSValue(undefinedIn: JSContext.xpringKit))
    }
    arguments.append(isTest)

    let result = utilsClass.invokeMethod(ResourceNames.Methods.encodeXAddress, withArguments: arguments as [Any])!
    return result.isUndefined ? nil : result.toString()
  }

  /// Decode a classic address from a given X-address.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter xAddress: The X-Address to decode.
  /// - Returns: a tuple containing the decoded address,  tag and bool indicating if the address was on a test network.
  public func decode(xAddress: XRPAddress) -> (classicAddress: String, tag: UInt32?, isTest: Bool)? {
    let result = utilsClass.invokeMethod(ResourceNames.Methods.decodeXAddress, withArguments: [ xAddress ])!
    guard !result.isUndefined else {
      return nil
    }

    let classicAddress = JavaScriptLoader.load(ResourceNames.Properties.address, from: result).toString()!
    let isTest = JavaScriptLoader.load(ResourceNames.Properties.test, from: result).toBool()
    if let tag = JavaScriptLoader.failableLoad(ResourceNames.Properties.tag, from: result) {
      return (classicAddress, tag.toUInt32(), isTest)
    }
    return (classicAddress, nil, isTest)
  }

  /// Convert the given transaction blob to a transaction hash.
  ///
  /// - Parameter transactionBlobHex: A hexadecimal encoded transaction blob.
  /// - Returns: A hex encoded hash if the input was valid, otherwise undefined.
  public func toTransactionHash(transactionBlobHex: Hex) -> Hex? {
    let result = utilsClass.invokeMethod(
      ResourceNames.Methods.transactionBlobToTransactionHash,
      withArguments: [transactionBlobHex]
    )!
    guard !result.isUndefined else {
      return nil
    }
    return result.toString()
  }
}
