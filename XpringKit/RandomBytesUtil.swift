/// A static utility class which securely generates random bytes.
public enum RandomBytesUtil {
  /// Generate an array of random bytes.
  ///
  /// - Parameter numBytes: The number of bytes to generate.
  /// - Returns: An array of random bytes.
  public static func randomBytes(numBytes: Int) -> [UInt8] {
    return [UInt8](repeating: 0, count: numBytes).map { _ in randomByte() }
  }

  /// Generate a cryptographically secure random byte.
  private static func randomByte() -> UInt8 {
    return UInt8.random(in: 0...UInt8.max)
  }
}
