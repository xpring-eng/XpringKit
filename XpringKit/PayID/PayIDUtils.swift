/// A static utility class for PayID.
public enum PayIDUtils {
  /// The underlying JavaScript based PayIDUtils.
  private static let javaScriptPayIDUtils = JavaScriptPayIDUtils()

  /// Parse a payment pointer string to a payment pointer object
  ///
  /// - Parameter paymentPointer: The input string payment pointer.
  /// - Returns: A  `PaymentPointer` object if the input was valid, otherwise undefined.
  public static func parse(paymentPointer: String) -> (host: String, path: String)? {
    return javaScriptPayIDUtils.parse(paymentPointer: paymentPointer)
  }
}
