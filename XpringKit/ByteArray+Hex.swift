/// Allows transformation of an array of bytes to a hexadecimal string.
extension Array where Element == UInt8 {
	public func toHex() -> Hex {
		let format = "%02hhX"
		return map { String(format: format, $0) }.joined()
	}
}
