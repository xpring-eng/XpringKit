/// Represents statuses of transactions.
public enum TransactionStatus: String {
    // The transaction was included in a finalized ledger and failed.
    case failed

    // The transaction is not included in a finalized ledger.
    case pending

    // The transaction was included in a finalized ledger and succeeded.
    case succeeded

    // The transaction status is unknown.
    case unknown
}
