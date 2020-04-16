import Foundation

/// A transaction on the XRP Ledger.
///
/// - SeeAlso: https://xrpl.org/transaction-formats.html
// TODO(keefertaylor): Modify this object to use X-Address format.
public struct XRPTransaction: Equatable {
  /// Common fields
  public let hash: String
  public let account: Address
  public let accountTransactionID: Data?
  public let fee: UInt64
  public let flags: RippledFlags?
  public let lastLedgerSequence: UInt32?
  public let memos: [XRPMemo]?
  public let sequence: UInt32
  public let signers: [XRPSigner]?
  public let signingPublicKey: Data
  public let sourceTag: UInt32?
  public let transactionSignature: Data
  public let type: XRPTransactionType
  public let timestamp: UInt64?
  public let deliveredAmount: String?

  /// Transaction specific fields, only one of the following will be set.
  public let paymentFields: XRPPayment?
}
