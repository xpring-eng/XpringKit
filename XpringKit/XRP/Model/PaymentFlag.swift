/// Flags used in payment transactions.
///
/// These are only flags which are utilized in Xpring SDK.
/// For the complete list of payment flags, see https://xrpl.org/payment.html#payment-flags
public struct PaymentFlag: OptionSet {
  public let rawValue: UInt32

  /// Flag values.
  public static let tfPartialPayment = PaymentFlag(rawValue: 1 << 17)

  /// Initialize a new PaymentFlag
  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
}
