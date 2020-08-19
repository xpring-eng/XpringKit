import Foundation

/// Represents a CheckCreate transaction on the XRP Ledger.
///
/// A CheckCreate transaction creates a Check object in the ledger, which is a deferred payment that can be cashed
/// by its intended destination.  The sender of this transaction is the sender of the Check.
///
/// - SeeAlso: https://xrpl.org/checkcreate.html
public struct XRPCheckCreate: Equatable {

  /// The unique address and (optional) destination tag of the account that can cash the Check,
  /// encoded as an X-address.
  /// - SeeAlso:  https://xrpaddress.info
  public let destinationXAddress: String

  /// Maximum amount of source currency the Check is allowed to debit the sender, including transfer fees on non-XRP currencies.
  /// The Check can only credit the destination with the same currency (from the same issuer, for non-XRP currencies).
  /// For non-XRP amounts, the nested field names MUST be lower-case.
  public let sendMax: XRPCurrencyAmount

  /// (Optional) Time after which the Check is no longer valid, in seconds since the Ripple Epoch.
  public let expiration: UInt32?

  /// (Optional) Arbitrary 256-bit hash representing a specific reason or identifier for this Check.
  public let invoiceId: String?
}
