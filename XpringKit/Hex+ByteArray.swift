/// Allows transformation of a hexadecimal strings to a set of bytes.
extension Hex {
  public func toBytes() throws -> [UInt8] {
    var startIndex = self.startIndex
    return stride(from: 0, to: count, by: 2).compactMap { _ in
      let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
      defer { startIndex = endIndex }
      return UInt8(self[startIndex..<endIndex], radix: 16)
    }
  }
}
