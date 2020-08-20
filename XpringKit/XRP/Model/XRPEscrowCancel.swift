import Foundation

/// Represents an EscrowCancel transaction on the XRP Ledger.
///
/// An EscrowCancel transaction returns escrowed XRP to the sender.
/// - SeeAlso: https://xrpl.org/escrowcancel.html
public struct XRPEscrowCancel: Equatable {

  /// Address of the source account that funded the escrow payment, encoded as an X-address.
  /// - seeAlso: https://xrpaddress.info
  public let ownerXAddress: String

  /// Transaction sequence of EscrowCreate transaction that created the escrow to cancel.
  public let offerSequence: UInt32
}
