/// Represents the outcome of submitting an XRPL transaction.
public struct TransactionResult {

  /// The identifying hash of the transaction.
  public let hash: TransactionHash

  /// The TransactionStatus indicating the outcome of this transaction.
  public let status: TransactionStatus

  /// Whether this transaction is included in a validated ledger.  The transactions status is only final if this field is true.
  public let validated: Bool

  /// Create a new TransactionResult object.
  public init(hash: TransactionHash, status: TransactionStatus, validated: Bool) {
    self.hash = hash
    self.status = status
    self.validated = validated
  }
}
