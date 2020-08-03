import Foundation

/// A transaction on the XRP Ledger.
///
/// - SeeAlso: https://xrpl.org/transaction-formats.html
// TODO(keefertaylor): Modify this object to use X-Address format.
public struct XRPTransaction: Equatable {
  /// Common fields

  /// The identifying hash of the transaction.
  public let hash: String

  /// (Optional) Hash value identifying another transaction. If provided, this transaction is only valid if
  /// the sending account's previously-sent transaction matches the provided hash.
  public let accountTransactionID: Data?

  /// Integer amount of XRP, in drops, to be destroyed as a cost for distributing this transaction to the network.
  public let fee: UInt64

  /// (Optional) Set of bit-flags for this transaction.
  public let flags: PaymentFlag?

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

  /// The unique address and source tag of the sender that initiated the transaction, encoded as an X-address.
  /// - SeeAlso: "https://xrpaddress.info"
  public let sourceXAddress: Address?

  /// The signature that verifies this transaction as originating from the account it says it is from.
  public let transactionSignature: Data

  /// The type of transaction.
  public let type: XRPTransactionType

  /// (Optional) The timestamp of the transaction reported in Unix time (seconds).
  /// - SeeAlso: "https://xrpl.org/basic-data-types.html#specifying-time"
  public let timestamp: UInt64?

  /// (Optional, omitted for non-Payment transactions) The Currency Amount actually received by the Destination account.
  /// Use this field to determine how much was delivered, regardless of whether the transaction is a partial payment.
  /// - SeeAlso: "https://xrpl.org/transaction-metadata.html#delivered_amount"
  public let deliveredAmount: String?

  /// A boolean indicating whether this transaction was found on a validated ledger, and not an open or closed ledger.
  /// - SeeAlso: "https://xrpl.org/ledgers.html#open-closed-and-validated-ledgers"
  public let validated: Bool

  /// The index of the ledger on which this transaction was found.
  public let ledgerIndex: UInt32

  /// Transaction specific fields, only one of the following will be set.

  /// An XRPPayment object representing the additional fields present in a PAYMENT transaction.
  /// - SeeAlso: https://xrpl.org/payment.html#payment-fields
  public let paymentFields: XRPPayment?
}
