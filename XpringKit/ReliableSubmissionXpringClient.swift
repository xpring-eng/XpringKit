import BigInt
import Foundation

/// A XpringClient which blocks on `send` calls until the transaction has reached a deterministic state.
public class ReliableSubmissionXpringClient {
    private let decoratedClient: XpringClientDecorator

    public init(decoratedClient: XpringClientDecorator) {
        self.decoratedClient = decoratedClient
    }
}

extension ReliableSubmissionXpringClient: XpringClientDecorator {

    public func getBalance(for address: Address) throws -> BigUInt {
        return try decoratedClient.getBalance(for: address)
    }

    public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
        return try decoratedClient.getTransactionStatus(for: transactionHash)
    }

    public func getLatestValidatedLedgerSequence() throws -> UInt32 {
        return try decoratedClient.getLatestValidatedLedgerSequence()
    }

    public func getRawTx(for transactionHash: TransactionHash) throws -> Rpc_V1_GetTxResponse {
        return try decoratedClient.getRawTx(for: transactionHash)
    }

    public func send(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
        let ledgerCloseTime: TimeInterval = 4

        // Submit a transaction hash and wait for a ledger to close.
        let transactionHash = try decoratedClient.send(amount, to: destinationAddress, from: sourceWallet)
        Thread.sleep(forTimeInterval: ledgerCloseTime)

        // Get transaction status.
        var transaction = try getRawTx(for: transactionHash)
        let lastLedgerSequence = transaction.ledgerIndex
        if lastLedgerSequence == 0 {
            throw XRPLedgerError.unknown("The transaction did not have a lastLedgerSequence field so transaction status cannot be reliably determined.")
        }

        // Retrieve the latest ledger index.
        var latestLedgerSequence = try getLatestValidatedLedgerSequence()

        // Poll until the transaction is validated, or until the lastLedgerSequence has been passed.
        while latestLedgerSequence <= lastLedgerSequence && !transaction.validated {
            Thread.sleep(forTimeInterval: ledgerCloseTime)

            latestLedgerSequence = try getLatestValidatedLedgerSequence()
            print("got latest: \(latestLedgerSequence)")
            transaction = try getRawTx(for: transactionHash)
        }

        return transactionHash
    }
}
