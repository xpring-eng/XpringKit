/// Provides a means of passing a string to a memo that allows for user
/// specification as to whether or not the string is already a hex string.
public struct MemoField {
  
  /// The string to be passed to the Memo
  public let value: String

  /// Whether this string is already hex-encoded or not.
  public let isHex: Bool
}
