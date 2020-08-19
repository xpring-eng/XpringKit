import Foundation

/// Represents a CheckCash transaction on the XRP Ledger.
///
/// Represents a CheckCash transaction on the XRP Ledger.
/// A CheckCash transaction attempts to redeem a Check object in the ledger to receive up to the amount
/// authorized by the corresponding CheckCreate transaction.
///
/// - SeeAlso: https://xrpl.org/checkcash.html
public struct XRPCheckCash: Equatable {

  ///The ID of the Check ledger object to cash, as a 64-character hexadecimal string.
  public let checkId: String

  /// (Optional) Redeem the Check for exactly this amount, if possible.
  /// The currency must match that of the SendMax of the corresponding CheckCreate transaction.
  /// You must provide either this field or deliverMin.
  public let amount: XRPCurrencyAmount?

  /// (Optional) Redeem the Check for at least this amount and for as much as possible.
  /// The currency must match that of the SendMax of the corresponding CheckCreate transaction.
  /// You must provide either this field or amount.
  public let deliverMin: XRPCurrencyAmount?
}
