/// Allows transformation of a hexadecimal strings to a set of bytes.
extension Hex {
  public func toBytes() throws -> [UInt8]? {
    guard self.count % 2 == 0 else {
      throw XRPLedgerError.invalidInputs("Invalid hex string length.")
    }

    let size = self.count / 2
    var result: [UInt8] = [UInt8](repeating: 0, count: size)

    // Stride though the string 2 characters at a time.
    for i in 0..<self.count / 2 {
      let startIndex = i * 2
      let index0 = self.index(self.startIndex, offsetBy: startIndex)
      let index1 = self.index(index0, offsetBy: 1)

      let character0 = self[index0]
      let character1 = self[index1]

      let byte = try toBase10(character0) + toBase10(character1)

      result[i] = byte
    }
    return result
  }

  /// Convert the given character to a byte value.
  ///
  /// - Parameter character: The character to convert.
  /// - Throws: An exception if the character is not a valid hexadecimal character.
  /// - Returns: The base 10 value of the given input.
  private func toBase10(_ character: Character) throws -> UInt8 {
    switch character {
    case "0":
      return 0 as UInt8
    case "1":
      return 1 as UInt8
    case "2":
      return 2 as UInt8
    case "3":
      return 3 as UInt8
    case "4":
      return 4 as UInt8
    case "5":
      return 5 as UInt8
    case "6":
      return 6 as UInt8
    case "7":
      return 7 as UInt8
    case "8":
      return 8 as UInt8
    case "9":
      return 9 as UInt8
    case "A", "a":
      return 10 as UInt8
    case "B", "b":
      return 11 as UInt8
    case "C", "c":
      return 12 as UInt8
    case "D", "d":
      return 13 as UInt8
    case "E", "e":
      return 14 as UInt8
    case "F", "f":
      return 15 as UInt8
    default:
      throw XRPLedgerError.invalidInputs("Non hex character in hexadecimal string")
    }
  }
}
