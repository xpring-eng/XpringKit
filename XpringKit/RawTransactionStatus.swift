/// A bridge between various model classes that represent raw transaction status.
public struct RawTransactionStatus {
  /// Whether the transaction has been validated.
  public let validated: Bool

  /// The transaction status code associated with the transaction.
  public let transactionStatusCode: String

  /// The last ledger sequence the transaction will be valid for.
  public let lastLedgerSequence: UInt32

  /// Whether Xpring SDK can bucket this transaction status into a TransactionStatus enum.
  public let isBucketable: Bool

  /// Initialize a new `RawTransactionStatus` from an `Io_Xpring_TransactionStatus`.
  public init(transactionStatus: Io_Xpring_TransactionStatus) {
    self.validated = transactionStatus.validated
    self.lastLedgerSequence = transactionStatus.lastLedgerSequence
    self.transactionStatusCode = transactionStatus.transactionStatusCode
    self.isBucketable = true
  }

  /// Initialize a new `RawTransactionStatus` from an `Rpc_V1_GetTxResponse`.
  public init(getTxResponse: Rpc_V1_GetTxResponse) {
    self.validated = getTxResponse.validated
    self.lastLedgerSequence = getTxResponse.transaction.lastLedgerSequence
    self.transactionStatusCode = getTxResponse.meta.transactionResult.result

    let flags = RippledFlags(rawValue: getTxResponse.transaction.flags)

    let isPayment = RawTransactionStatus.isPayment(transaction: getTxResponse.transaction)
    let isPartialPayment = flags.contains(.tfPartialPayment)
    self.isBucketable = isPayment && !isPartialPayment
  }

  /// Check if a transaction is a Payment transaction.
  private static func isPayment(transaction: Rpc_V1_Transaction) -> Bool {
    if
      let transactionData = transaction.transactionData,
      case .payment = transactionData
    {
      return true
    } else {
      return false
    }
  }
}

extension RawTransactionStatus: Equatable {
}
