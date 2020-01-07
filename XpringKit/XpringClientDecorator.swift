import BigInt
import Foundation

/// A decorator for a XpringClient.
public protocol XpringClientDecorator {
    /// Get the balance for the given address.
    ///
    /// - Parameter address: The X-Address to retrieve the balance for.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: An unsigned integer containing the balance of the address in drops.
    func getBalance(for address: Address) throws -> BigUInt

//    /// Retrieve the transaction data for a given transaction hash.
//    ///
//    /// - Parameter transactionHash: The hash of the transaction.
//    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
//    /// - Returns: The data of the given transaction.
//    func getTransactionData(for transactionHash: TransactionHash) throws -> TransactionData

    /// Retrieve the transaction status for a given transaction hash.
    ///
    /// - Parameter transactionHash: The hash of the transaction.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The status of the given transaction.
    func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus

    /// Sign XRP transaction for submission on the XRP Ledger.
    ///
    /// - Parameters:
    ///    - amount: An unsigned integer representing the amount of XRP to send.
    ///    - destinationAddress: The X-Address which will receive the XRP.
    ///    - sourceWallet: The wallet sending the XRP.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: A signed transaction for submission on the XRP Ledger.
    func sign(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Io_Xpring_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Io_Xpring_SignedTransaction

    /// Send XRP to a recipient on the XRP Ledger.
    ///
    /// - Parameters:
    ///    - signedTransaction: An unsigned integer representing the amount of XRP to send.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: A transaction hash for the submitted transaction.
    func send(_ signedTransaction: Io_Xpring_SignedTransaction) throws -> TransactionHash

    /// Retrieve the latest validated ledger sequence on the XRP Ledger.
    ///
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The index of the latest validated ledger.
    func getLatestValidatedLedgerSequence() throws -> UInt32

//    /// Retrieve the raw transaction data for the given transaction hash.
//    ///
//    /// - Parameter transactionHash: The hash of the transaction.
//    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
//    /// - Returns: The data of the given transaction.
//    func getRawTransactionData(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionData

    /// Retrieve the raw transaction status for the given transaction hash.
    ///
    /// - Parameter transactionHash: The hash of the transaction.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The status of the given transaction.
    func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionStatus
}
