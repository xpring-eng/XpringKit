import Foundation

/// Represents an EscrowCreate transaction on the XRP Ledger.
///
/// An EscrowCreate transaction sequesters XRP until the escrow process either finishes or is canceled.
/// - SeeAlso: https://xrpl.org/escrowcreate.html
public struct XRPEscrowCreate: Equatable {

  /// Amount of XRP, in drops, to deduct from the sender's balance and escrow.
  /// Once escrowed, the XRP can either go to the destination address (after the FinishAfter time)
  /// or returned to the sender (after the CancelAfter time).
  public let amount: XRPCurrencyAmount

  /// Address and (optional) destination tag to receive escrowed XRP, encoded as an X-address.
  /// - SeeAlso: https://xrpaddress.info
  public let destinationXAddress: String

  /// (Optional) The time, in seconds since the Ripple Epoch, when this escrow expires.
  /// This value is immutable; the funds can only be returned the sender after this time.
  public let cancelAfter: UInt32?

  /// (Optional) The time, in seconds since the Ripple Epoch, when the escrowed XRP can be released to the recipient.
  /// This value is immutable; the funds cannot move until this time is reached.
  public let finishAfter: UInt32?

  /// (Optional) Hex value representing a PREIMAGE-SHA-256 crypto-condition.
  /// The funds can only be delivered to the recipient if this condition is fulfilled.
  public let condition: String?
}
