import BigInt
import Foundation
import XpringKit

/// A  fake XpringClient which returns the given iVars as results from XpringClientDecorator calls.
/// - Note: Since this class is passed by reference and the iVars are mutable, outputs of this class can be changed after it is injected.
public class FakeXpringClient {
    public let networkClient: NetworkClient = FakeNetworkClient.successfulFakeNetworkClient

    public var getBalanceValue: BigUInt
    public var transactionValue: Rpc_V1_GetTxResponse
    public var sendValue: Rpc_V1_SubmitTransactionResponse
//    public var latestValidatedLedgerValue: UInt32
    public var rawTransactionValue: Rpc_V1_GetTxResponse

    public init(
        getBalanceValue: BigUInt,
        transactionValue: Rpc_V1_GetTxResponse,
        sendValue: Rpc_V1_SubmitTransactionResponse,
        //    latestValidatedLedgerValue: UInt32,
        rawTransactionValue: Rpc_V1_GetTxResponse
    ) {
        self.getBalanceValue = getBalanceValue
        self.transactionValue = transactionValue
        self.sendValue = sendValue
        //    self.latestValidatedLedgerValue = latestValidatedLedgerValue
        self.rawTransactionValue = rawTransactionValue
    }
}

extension FakeXpringClient: XpringClientDecorator {

    public func getBalance(for address: Address) throws -> BigUInt {
        return getBalanceValue
    }

    public func getTx(for transactionHash: TransactionHash) throws -> Rpc_V1_GetTxResponse {
        return transactionValue
    }

    public func submitTransaction(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Rpc_V1_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Rpc_V1_SubmitTransactionResponse {
        return sendValue
    }

    public func getRawTx(for transactionHash: TransactionHash) throws -> Rpc_V1_GetTxResponse {
        return rawTransactionValue
    }

    public func submitRawTransaction(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Rpc_V1_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Rpc_V1_SubmitTransactionResponse {
        return sendValue
    }
}
