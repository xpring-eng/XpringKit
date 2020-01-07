import BigInt

/// An interface into the Xpring Platform.
public class XpringClient {
    private let decoratedClient: XpringClientDecorator

    /// Initialize a new XpringClient.
    ///
    /// - Parameter grpcURL: A remote URL for a rippled gRPC service.
    public init(grpcURL: String) {
        let defaultClient = DefaultXpringClient(grpcURL: grpcURL)
        decoratedClient = ReliableSubmissionXpringClient(decoratedClient: defaultClient)
    }

    /// Get the balance for the given address.
    ///
    /// - Parameter address: The X-Address to retrieve the balance for.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: An unsigned integer containing the balance of the address in drops.
    public func getBalance(for address: Address) throws -> BigUInt {
        return try decoratedClient.getBalance(for: address)
    }

//    /// Retrieve the transaction data for a given transaction hash.
//    ///
//    /// - Parameter transactionHash: The hash of the transaction.
//    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
//    /// - Returns: The data of the given transaction.
//    public func getTransactionData(for transactionHash: TransactionHash) throws -> TransactionData {
//        return try decoratedClient.getTransactionData(for: transactionHash)
//    }

    /// Retrieve the transaction status for a given transaction hash.
    ///
    /// - Parameter transactionHash: The hash of the transaction.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The status of the given transaction.
    public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
        return try decoratedClient.getTransactionStatus(for: transactionHash)
    }

    /// Sign XRP transaction for submission on the XRP Ledger.
    ///
    /// - Parameters:
    ///    - amount: An unsigned integer representing the amount of XRP to send.
    ///    - destinationAddress: The X-Address which will receive the XRP.
    ///    - sourceWallet: The wallet sending the XRP.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: A signed transaction for submission on the XRP Ledger.
    public func sign(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> Io_Xpring_SignedTransaction {
        return try decoratedClient.sign(amount, to: destinationAddress, from: sourceWallet)
    }

    /// Send XRP to a recipient on the XRP Ledger.
    ///
    /// - Parameters:
    ///    - amount: An unsigned integer representing the amount of XRP to send.
    ///    - destinationAddress: The X-Address which will receive the XRP.
    ///    - sourceWallet: The wallet sending the XRP.
    ///    - invoiceID: The invoiceID of the transaction.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: A transaction hash for the submitted transaction.
    public func send(_ signedTransaction: Io_Xpring_SignedTransaction) throws -> TransactionHash {
        return try decoratedClient.send(signedTransaction: signedTransaction)
    }
}
