/// Represents statuses of transactions.
public enum TransactionStatus {
  // The transaction was included in a finalized ledger and failed.
  case failed

  // The transaction is not included in a finalized ledger.
  case pending

  // The transaction was included in a finalized ledger and succeeded.
  case succeeded

  // The transaction status is unknown.
  case unknown
}

public enum TransactionData {
    private static let ledgerIndex: Int = 0
    private static let timeStamp: Int = 0
    private static let hash: String = ""
    private static let transactionIndex: Int = 0
    private static let transactionResult: String = ""
    private static let transactionType: String = ""
    private static let sender: String = ""
    private static let to: String = ""
    private static let value: String = ""
    private static let fee: Int = 0
    private static let sequence: Int = 0
    private static let validated: Bool = false
}
