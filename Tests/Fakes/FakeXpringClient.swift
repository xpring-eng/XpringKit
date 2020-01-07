import BigInt
import Foundation
import XpringKit

/// A  fake XpringClient which returns the given iVars as results from XpringClientDecorator calls.
/// - Note: Since this class is passed by reference and the iVars are mutable, outputs of this class can be changed after it is injected.
public class FakeXpringClient {
    public let networkClient: NetworkClient = FakeNetworkClient.successfulFakeNetworkClient

    public var getBalanceValue: BigUInt
    public var transactionStatusValue: TransactionStatus
    public var sendValue: TransactionHash
    public var signedTransaction: Io_Xpring_SignedTransaction
    public var latestValidatedLedgerValue: UInt32
    public var rawTransactionStatusValue: Io_Xpring_TransactionStatus

    public init(
        getBalanceValue: BigUInt,
        transactionStatusValue: TransactionStatus,
        sendValue: TransactionHash,
        signedTransaction: Io_Xpring_SignedTransaction,
        latestValidatedLedgerValue: UInt32,
        rawTransactionStatusValue: Io_Xpring_TransactionStatus
    ) {
        self.getBalanceValue = getBalanceValue
        self.transactionStatusValue = transactionStatusValue
        self.sendValue = sendValue
        self.signedTransaction = signedTransaction
        self.latestValidatedLedgerValue = latestValidatedLedgerValue
        self.rawTransactionStatusValue = rawTransactionStatusValue
    }
}

extension FakeXpringClient: XpringClientDecorator {

    public func getBalance(for address: Address) throws -> BigUInt {
        return getBalanceValue
    }

    public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
        return transactionStatusValue
    }

    public func sign(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Io_Xpring_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Io_Xpring_SignedTransaction {
        return signedTransaction
    }

    public func send(_ signedTransaction: Io_Xpring_SignedTransaction) throws -> TransactionHash {
        return sendValue
    }

    public func getLatestValidatedLedgerSequence() throws -> UInt32 {
        return latestValidatedLedgerValue
    }

    public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionStatus {
        return rawTransactionStatusValue
    }
}
