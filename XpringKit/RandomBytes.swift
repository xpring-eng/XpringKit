public enum RandomBytes {
	public static func randomBytes(numBytes: Int) -> [UInt8] {
		return [UInt8](repeating: 0, count: numBytes).map { _ in randomByte() }
	}

	public static func randomByte() -> UInt8 {
		return UInt8.random(in: 0...UInt8.max)
	}
}

extension Array where Element == UInt8 {
	public func toHex() -> String {
		let format = "%02hhX"
		return map { String(format: format, $0) }.joined()
	}
}
