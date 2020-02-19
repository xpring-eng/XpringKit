/// Flags used in ripppled transactions.
///
/// These are only flags which are utilized in Xpring SDK. For a complete list of flags, see:
/// https://xrpl.org/transaction-common-fields.html#flags-field.
public struct RippledFlags: OptionSet {
  public let rawValue: UInt32

  /// Flag values.
  public static let tfPartialPayment = RippledFlags(rawValue: 131_072)

  /// Initialize a new RippledFlag
  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
}
