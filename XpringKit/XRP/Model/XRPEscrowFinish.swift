import Foundation

/// Represents an EscrowFinish transaction on the XRP Ledger.
///
/// An EscrowFinish transaction delivers XRP from a held payment to the recipient.
/// - SeeAlso: https://xrpl.org/escrowfinish.html
public struct XRPEscrowFinish: Equatable {
  
  /// Address of the source account that funded the held payment, encoded as an X-address
  /// - seeAlso: https://xrpaddress.info
  public let ownerXAddress: Address
  
  /// Transaction sequence of EscrowCreate transaction that created the held payment to finish.
  public let offerSequence: UInt32
  
  /// (Optional) Hex value matching the previously-supplied PREIMAGE-SHA-256 crypto-condition  of the held payment.
  public let condition: String?
  
  /// (Optional) Hex value of the PREIMAGE-SHA-256 crypto-condition fulfillment  matching the held payment's Condition.
  public let fulfillment: String?
}
