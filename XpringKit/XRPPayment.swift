import Foundation

/// A payment on the XRP Ledger
/// - SeeAlso: https://xrpl.org/payment.html
// TODO(keefertaylor): Modify this object to use X-Address format.
public struct XRPPayment: Equatable {
  public let amount: XRPCurrencyAmount
  public let destination: Address
  public let destinationTag: UInt32?
  public let deliverMin: XRPCurrencyAmount?
  public let invoiceID: Data?
  public let paths: [XRPPath]?
  public let sendMax: XRPCurrencyAmount?
}
