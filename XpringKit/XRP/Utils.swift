import Foundation

/// Provides utility functions for working in the XRP Ecosystem.
public enum Utils {
  /// The underlying JavaScript based utilities.
  private static let javaScriptUtils = JavaScriptUtils()

  /// Check if the given address is a valid XRP address.
  ///
  /// - Note: This function only checks that the address is a valid address, the activation status of the address on the
  ///         ledger is not checked by this function.
  ///
  /// - Parameter address: The address to validate.
  ///	- Returns: true if the address is valid, otherwise false.
  public static func isValid(address: Address) -> Bool {
    return javaScriptUtils.isValid(address: address)
  }

  /// Validate if the given string is a valid X-address on the XRP Ledger.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter address: An address to check.
  /// - Returns true if the address is a valid X-address, otherwise false.
  public static func isValidXAddress(address: Address) -> Bool {
    return javaScriptUtils.isValidXAddress(address: address)
  }

  /// Validate if the given string is a valid  classic address on the XRP Ledger.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter address: An address to check.
  /// - Returns true if the address is a valid classic address, otherwise false.
  public static func isValidClassicAddress(address: Address) -> Bool {
    return javaScriptUtils.isValidClassicAddress(address: address)
  }

  /// Encode the given classic address and tag into an x-address.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameters:
  ///   -  classicAddress: A classic address to encode.
  ///   - tag: An optional tag to encode. Defaults to nil.
  ///   - isTest Whether the address is for use on a test network, defaults to `false`.
  /// - Returns: A new x-address if inputs were valid, otherwise undefined.
  public static func encode(classicAddress: Address, tag: UInt32? = nil, isTest: Bool = false) -> Address? {
    return javaScriptUtils.encode(classicAddress: classicAddress, tag: tag, isTest: isTest)
  }

  /// Decode a classic address from a given x-address.
  ///
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter xAddress: The xAddress to decode.
  /// - Returns: a tuple containing the decoded address,  tag and bool indicating if the address was on a test network.
  public static func decode(xAddress: Address) -> (classicAddress: String, tag: UInt32?, isTest: Bool)? {
    return javaScriptUtils.decode(xAddress: xAddress)
  }

  /// Convert the given transaction blob to a transaction hash.
  ///
  /// - Parameter transactionBlobHex: A hexadecimal encoded transaction blob.
  /// - Returns: A hex encoded hash if the input was valid, otherwise undefined.
  public static func toTransactionHash(transactionBlobHex: Hex) -> Hex? {
    return javaScriptUtils.toTransactionHash(transactionBlobHex: transactionBlobHex)
  }
  
  
  /// Convert from units in drops to XRP.
  ///
  /// - Parameter drops: An amount of XRP expressed in units of drops.
  /// - Returns: A String representing the drops amount in units of XRP.
  /// - Throws: IllegalArgumentException if drops is in an invalid format.
  public static func dropsToXrp(_ drops: String) throws -> String {
    // any preconditions to check?

    let dropsRegex: String = "^-?[0-9]*['.']?[0-9]*$"
    if drops.range(of: dropsRegex, options: .regularExpression) == nil {
      throw XRPLedgerError.invalidDropsValue(String(
        format: "dropsToXrp: invalid value %s, should be a number matching %s.", drops, dropsRegex))
    } else if (drops == ".") {
      throw XRPLedgerError.invalidDropsValue(String(
        format: "dropsToXrp: invalid value %s, should be a string-encoded number.", drops))
    }

    // check for non-zero fractional amount in drops value
    if drops.contains(".") {
      let splitdrops: [Substring] = drops.split(separator: ".")
      if splitdrops.count > 2 {
        throw XRPLedgerError.invalidDropsValue(String(
          format: "dropsToXrp: invalid value, %s has too many decimal points.", drops))
      }
      if splitdrops.count == 1 && drops.starts(with: ".") {
        if UInt64(splitdrops[0]) != 0 {
          throw XRPLedgerError.invalidDropsValue(String(
            format:"dropsToXrp: value %s must be a whole number.", drops))
          }
        }
      }
    return NSDecimalNumber(string: drops).dividing(by: NSDecimalNumber(1000000.0)).description(withLocale: Locale(identifier: "en_US"))
  }

  /**
   * Convert from units in XRP to drops.
   *
   * @param xrp An amount of XRP expressed in units of XRP.
   * @return A String representing an amount of XRP expressed in units of drops.
   * @throws IllegalArgumentException if xrp is in invalid format.
   */
  public static func xrpToDrops(_ xrp: String) throws -> String {
    // preconditions check?
    xrpRegex: String = "^-?[0-9]*['.']?[0-9]*$"
    if (!xrpMatcher.matches()) {
      throw new IllegalArgumentException(String.format(
              "xrpToDrops: invalid value, %s should be a number matching %s.", xrp, xrpRegex))
    } else if (xrp.equals(".")) {
      throw new IllegalArgumentException(String.format(
              "xrpToDrops: invalid value, %s should be a BigDecimal or string-encoded number.", xrp))
    }

    // Converting to BigDecimal and then back to string should remove any
    // decimal point followed by zeros, e.g. '1.00'.
    // Important: use toPlainString() to avoid exponential notation, e.g. '1e-7'.
    xrp = new BigDecimal(xrp).stripTrailingZeros().toPlainString()

    // This should never happen; the value has already been validated above.
    // This just ensures BigDecimal did not do something unexpected.
    if (!xrpMatcher.matches()) {
      throw new IllegalArgumentException(String.format(
              "xrpToDrops: failed sanity check - value %s does not match %s.", xrp, xrpRegex))
    }

    String[] components = xrp.split("[.]")
    if (components.length > 2) {
      throw new IllegalArgumentException(String.format(
              "xrpToDrops: failed sanity check - value %s has too many decimal points.", xrp))
    }
    String fraction = "0";
    if (components.length == 2) {
      fraction = components[1]
    }
    if (fraction.length() > 6) {
      throw new IllegalArgumentException(String.format("xrpToDrops: value %s has too many decimal places.", xrp))
    }
    return new BigDecimal(xrp)
            .multiply(new BigDecimal(1000000.0))
            .toBigInteger()
            .toString(10)
  }
}
