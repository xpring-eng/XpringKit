/// Flags used in ripppled transactions.
///
/// These are only flags which are utilized in Xpring SDK. For a complete list of flags, see:
/// https://xrpl.org/transaction-common-fields.html#flags-field.
public struct RippledFlags: OptionSet {
  public let rawValue: Int

  /// Flag values.
  public static let tfPartialPayment = 131_072

  /// Initialize a new RippledFlag
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}
