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

    /// Convert the given string to a Uint8 byte array.
    ///
    /// - Parameter hex: A string.
    /// - Returns: A byte array in [UInt8].
    public static func toByteArray(hex: Hex) -> [UInt8] {
        // remove "-" from Hexadecimal
        let size = hex.count / 2
        var result: [UInt8] = [UInt8]( repeating: 0, count: size) // array with length = size
        for i in stride(from: 0, to: hex.count, by: 2) {
            guard let uint8 = UInt8(hex.dropString(i, length: 2), radix: 16) else {
                return []
            }
            result[i / 2] = uint8
        }
        return result
    }
}

extension String {
    func dropString(_ from: Int, length: Int) -> String {
        if from < 0 || length + from > self.count { return "" }
        var result = ""
        for (idx, char) in self.enumerated() { if idx >= from && idx < length + from { result.append(char) } }
        return result
    }
}
