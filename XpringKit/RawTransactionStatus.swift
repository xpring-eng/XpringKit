/// A bridge between various model classes that represent raw transaction status.
public struct RawTransactionStatus {
  /// Whether the transaction has been validated.
  public let validated: Bool

  /// The transaction status code associated with the transaction.
  public let transactionStatusCode: String

  /// The last ledger sequence the transaction will be valid for.
  public let lastLedgerSequence: UInt32

  /// Initialize a new `RawTransactionStatus` from an `Io_Xpring_TransactionStatus`.
  public init(transactionStatus: Io_Xpring_TransactionStatus) {
    self.validated = transactionStatus.validated
    self.lastLedgerSequence = transactionStatus.lastLedgerSequence
    self.transactionStatusCode = transactionStatus.transactionStatusCode
  }

  /// Initialize a new `RawTransactionStatus` from an `Org_Xrpl_Rpc_V1_GetTransactionResponse`.
  public init(getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse) {
    self.validated = getTransactionResponse.validated
    self.lastLedgerSequence = getTransactionResponse.transaction.lastLedgerSequence.value
    self.transactionStatusCode = getTransactionResponse.meta.transactionResult.result
  }
}

extension RawTransactionStatus: Equatable {
}
