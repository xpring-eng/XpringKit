/// Represents a transaction on the XRP Ledger.
public class Transaction {

    /// Returns the validated statue of this `Transaction` on the XRP Ledger.
    public var validated: Bool?

    /// Returns a last ledger index corresponding to this `Transaction`.
    public var ledgerIndex: UInt32?

    /// Returns a `TransactionStatus for this `Transaction`.
    public var status: TransactionStatus?

    /// Returns the `Rpc_V1_TransactionResult.ResultType` corresponding to this `Transaction`.
    public var resultType: Rpc_V1_TransactionResult.ResultType?

    /// Returns the delivered amount as `Rpc_V1_CurrencyAmount` corresponding to this `Transaction`.
    public var deliveredAmount: Rpc_V1_CurrencyAmount?

        /// Returns a string transaction result corresponding to this `Transaction`.
        public var transactionResult: String { return "tecUNKNOWN" }

    /// Initialize a new `Transaction` with a transaction response from the xrp ledger.
    ///
    /// - Parameters:
    /// - receipt: A `Rpc_V1_GetTxResponse` for the `Transaction`.
    /// - Returns: A new transaction if inputs were valid, otherwise nil.
    public convenience init?(receipt: Rpc_V1_GetTxResponse) {
        self.init(transaction: receipt)
    }

    internal func parseTransactionStatus(resultType: Rpc_V1_TransactionResult.ResultType) -> TransactionStatus {
        // TODO: Finish Parsing
        switch resultType {
        case .tes:
            return TransactionStatus.succeeded
        case .tec:
            return TransactionStatus.failed
        default:
            return TransactionStatus.unknown
        }
    }

    /// Initialize a new `Transaction` backed by the given Get Tx Responset.
    // TODO: Return nil if not valid
    internal init(transaction: Rpc_V1_GetTxResponse) {
        self.validated = transaction.validated
        self.ledgerIndex = transaction.ledgerIndex
        self.resultType = transaction.meta.transactionResult.resultType
        self.status = parseTransactionStatus(resultType: transaction.meta.transactionResult.resultType)
        // Override Result if NOT Validated
        if self.validated == false {
            self.status = .pending
        }
        self.deliveredAmount = transaction.meta.deliveredAmount
    }
}
