import Foundation

/// A transaction on the XRP Ledger.
///
/// - SeeAlso: https://xrpl.org/transaction-formats.html
// TODO(keefertaylor): Modify this object to use X-Address format.
public struct XRPTransaction: Equatable {
  /// Common fields

  /// The unique address of the account that initiated the transaction.
  public let account: Address

  /// (Optional) Hash value identifying another transaction. If provided, this transaction is only valid if
  /// the sending account's previously-sent transaction matches the provided hash.
  public let accountTransactionID: Data?

  /// Integer amount of XRP, in drops, to be destroyed as a cost for distributing this transaction to the network.
  public let fee: UInt64

  /// (Optional) Set of bit-flags for this transaction.
  public let flags: RippledFlags?

  /// (Optional; strongly recommended) Highest ledger index this transaction can appear in.
  /// Specifying this field places a strict upper limit on how long the transaction can wait to be
  /// validated or rejected.
  public let lastLedgerSequence: UInt32?

  /// (Optional) Additional arbitrary information used to identify this transaction.
  public let memos: [XRPMemo]?

  /// The sequence number of the account sending the transaction.  A transaction is only valid if the Sequence
  /// number is exactly 1 greater than the previous transaction from the same account.
  public let sequence: UInt32

  /// (Optional) Array of objects that represent a multi-signature which authorizes this transaction.
  public let signers: [XRPSigner]?

  /// Hex representation of the public key that corresponds to the private key used to sign this transaction.
  /// If an empty string, indicates a multi-signature is present in the Signers field instead.
  public let signingPublicKey: Data

  /// (Optional) Arbitrary integer used to identify the reason for this payment or a sender on whose behalf this
  /// transaction is made.
  /// Conventionally, a refund should specify the initial payment's SourceTag as the refund payment's DestinationTag.
  public let sourceTag: UInt32?

  /// The signature that verifies this transaction as originating from the account it says it is from.
  public let transactionSignature: Data

  /// The type of transaction.
  public let type: XRPTransactionType

  /// Transaction specific fields, only one of the following will be set.

  /// An XRPPayment object representing the additional fields present in a PAYMENT transaction.
  /// - SeeAlso: https://xrpl.org/payment.html#payment-fields
  public let paymentFields: XRPPayment?
}
