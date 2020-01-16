import XpringKit

/// A fake network client which faekse calls.
public class FakeNetworkClient {
    /// Result of a call to getAccountInfo
    private let accountInfoResult: Result<Rpc_V1_GetAccountInfoResponse, Error>

    /// Result of a call to getFee
    private let feeResult: Result<Rpc_V1_GetFeeResponse, Error>

    /// Result of a call to submitSignedTransaction.
    private let submitTransactionResult: Result<Rpc_V1_SubmitTransactionResponse, Error>

    /// Result of a call to getLatestValidatedLedgerSequence.
    //  private let latestValidatedLedgerSequenceResult: Result<Rpc_V1_LedgerSequence, Error>
    /// Result of a call to gettransaction.
    private let transactionResult: Result<Rpc_V1_GetTxResponse, Error>

    /// Initialize a new fake NetworkClient.
    ///
    /// - Parameters:
    ///   - accountInfoResult: A result which will be used to determine the behavior of getAccountInfo().
    ///   - feeResult: A result which will be used to determine the behavior of getFee().
    ///   - submitTransactionResult: A result which will be used to determine the behavior of submitSignedTransaction().
    ///   - latestValidatedLedgerSequenceResult: A result which will be used to determine behavior of getLatestValidatedLedgerSequence().
    ///   - transactionResult: A result which will be used to determine behavior of gettransaction().
    public init(
        accountInfoResult: Result<Rpc_V1_GetAccountInfoResponse, Error>,
        feeResult: Result<Rpc_V1_GetFeeResponse, Error>,
        submitTransactionResult: Result<Rpc_V1_SubmitTransactionResponse, Error>,
        //    latestValidatedLedgerSequenceResult: Result<Rpc_V1_LedgerSequence, Error>,
        transactionResult: Result<Rpc_V1_GetTxResponse, Error>
    ) {
        self.accountInfoResult = accountInfoResult
        self.feeResult = feeResult
        self.submitTransactionResult = submitTransactionResult
        //    self.latestValidatedLedgerSequenceResult = latestValidatedLedgerSequenceResult
        self.transactionResult = transactionResult
    }
}

/// Conform to NetworkClient protocol, returning faked results.
extension FakeNetworkClient: NetworkClient {
    public func getAccountInfo(_ request: Rpc_V1_GetAccountInfoRequest) throws -> Rpc_V1_GetAccountInfoResponse {
        switch accountInfoResult {
        case .success(let accountInfo):
            return accountInfo
        case .failure(let error):
            throw error
        }
    }

    public func getFee(_ request: Rpc_V1_GetFeeRequest) throws -> Rpc_V1_GetFeeResponse {
        switch feeResult {
        case .success(let fee):
            return fee
        case .failure(let error):
            throw error
        }
    }

    public func submitTransaction(_ request: Rpc_V1_SubmitTransactionRequest) throws -> Rpc_V1_SubmitTransactionResponse {
        switch submitTransactionResult {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

    public func getTx(_ request: Rpc_V1_GetTxRequest) throws -> Rpc_V1_GetTxResponse {
        switch transactionResult {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
}
