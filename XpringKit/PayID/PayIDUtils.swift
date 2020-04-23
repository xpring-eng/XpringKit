/// A static utility class for PayID.
public enum PayIDUtils {
  /// The underlying JavaScript based PayIDUtils.
  private static let javaScriptPayIDUtils = JavaScriptPayIDUtils()

  /// Parse the given Pay ID to a set of components.
  ///
  /// - Parameter payID: A PayID to parse.
  /// - Returns: A set of components parsed from the PayID.
  public static func parse(payID: String) -> (host: String, path: String)? {
    return javaScriptPayIDUtils.parse(payID: payID)
  }
}
