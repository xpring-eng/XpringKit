import Foundation

/// A payment on the XRP Ledger
/// - SeeAlso: https://xrpl.org/payment.html
public struct XRPPayment: Equatable {
  // TODO(keefertaylor): Modify this object to use X-Address format.

  /// The amount of currency to deliver.
  public let amount: XRPCurrencyAmount

  /// The unique address of the account receiving the payment.
  @available(*, deprecated, message: "Please use destinationXAddress, which encodes both the destination and destinationTag")
  public let destination: Address

  /// (Optional) Arbitrary tag that identifies a hosted recipient to pay, or the reason for the payment.
  @available(*, deprecated, message: "Please use destinationXAddress, which encodes both the destination and destinationTag")
  public let destinationTag: UInt32?

  /// The address and (optional) destination tag of the account receiving the payment, encoded in X-address format.
  /// - SeeAlso: https://xrpaddress.info
  public let destinationXAddress: Address?

  /// (Optional) Minimum amount of destination currency this transaction should deliver.
  public let deliverMin: XRPCurrencyAmount?

  /// (Optional) Arbitrary 256-bit hash representing a specific reason or identifier for this payment.
  public let invoiceID: Data?

  /// (Optional) Array of payment paths to be used for this transaction. Must be omitted for XRP-to-XRP transactions.
  public let paths: [XRPPath]?

  /// (Optional) Highest amount of source currency this transaction is allowed to cost.
  public let sendMax: XRPCurrencyAmount?
}
