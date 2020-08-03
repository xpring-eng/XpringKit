/// Represents the outcome of submitting an XRPL transaction.
public struct TransactionResult {
  public let hash: TransactionHash
  public let status: TransactionStatus
  public let validated: Bool

  /// Create a new TransactionResult object.
  ///
  /// - Parameters:
  ///   - hash: The identifying hash of the transaction.
  ///   - status: The TransactionStatus indicating the outcome of this transaction.
  ///   - validated: Whether this transaction is included in a validated ledger.
  ///                The transactions status is only final if this field is true.
  ///
  public init(hash: TransactionHash, status: TransactionStatus, validated: Bool) {
    self.hash = hash
    self.status = status
    self.validated = validated
  }
}
