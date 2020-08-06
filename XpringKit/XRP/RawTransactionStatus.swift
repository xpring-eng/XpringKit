/// A bridge between various model classes that represent raw transaction status.
// TODO(keefertaylor): This class no longer needs to exist. Refactor helper methods and remove.
public struct RawTransactionStatus {
  /// Whether the transaction has been validated.
  public let validated: Bool

  /// The transaction status code associated with the transaction.
  public let transactionStatusCode: String

  /// The last ledger sequence the transaction will be valid for.
  public let lastLedgerSequence: UInt32

  /// Whether Xpring SDK can bucket this transaction status into a TransactionStatus enum.
  public let isFullPayment: Bool

  /// Initialize a new `RawTransactionStatus` from an `Org_Xrpl_Rpc_V1_GetTransactionResponse`.
  public init(getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse) {
    self.validated = getTransactionResponse.validated
    self.lastLedgerSequence = getTransactionResponse.transaction.lastLedgerSequence.value
    self.transactionStatusCode = getTransactionResponse.meta.transactionResult.result

    let flags = PaymentFlag(rawValue: getTransactionResponse.transaction.flags.value)

    let isPayment = RawTransactionStatus.isPayment(transaction: getTransactionResponse.transaction)
    let isPartialPayment = flags.contains(.tfPartialPayment)
    self.isFullPayment = isPayment && !isPartialPayment
  }

  /// Check if a transaction is a Payment transaction.
  private static func isPayment(transaction: Org_Xrpl_Rpc_V1_Transaction) -> Bool {
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
