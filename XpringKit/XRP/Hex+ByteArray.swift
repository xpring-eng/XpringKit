import Foundation

/// Allows transformation of a hexadecimal strings to a set of bytes.
extension Hex {
  public func toBytes() throws -> [UInt8] {
    guard self.count % 2 == 0 else {
      throw XRPLedgerError.invalidInputs("Invalid length for hexadecimal string.")
    }

    guard isValidHex() else {
      throw XRPLedgerError.invalidInputs("String contained non-hexadecimal characters")
    }

    // Process the string two characters at a time.
    return stride(from: 0, to: count, by: 2).compactMap { index in
      // Create `String.Index` values for the next pair of characters.
      let startIndex = self.index(self.startIndex, offsetBy: index)
      let endIndex = self.index(startIndex, offsetBy: 2)

      // Convert the next pair of hexadecimal character to a UInt8.
      return UInt8(self[startIndex..<endIndex], radix: 16)
    }
  }

  /// Checks whether this string is valid hex.
  private func isValidHex() -> Bool {
    let chars = CharacterSet(charactersIn: "0123456789ABCDEF")
    guard uppercased().rangeOfCharacter(from: chars) != nil else {
      return false
    }
    return true
  }
}
