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

    var startIndex = self.startIndex
    return stride(from: 0, to: count, by: 2).compactMap { _ in
      let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
      defer { startIndex = endIndex }

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
