import XpringKit

/// A fake network client which fakes calls.
public class FakeNetworkClient {
  /// Result of a call to getAccountInfo
  private let accountInfoResult: Result<Org_Xrpl_Rpc_V1_GetAccountInfoResponse, Error>

  /// Result of a call to getFee
  private let feeResult: Result<Org_Xrpl_Rpc_V1_GetFeeResponse, Error>

  /// Result of a call to submitSignedTransaction.
  private let submitTransactionResult: Result<Org_Xrpl_Rpc_V1_SubmitTransactionResponse, Error>

  /// Result of a call to getTransactionStatus.
  private let transactionStatusResult: Result<Org_Xrpl_Rpc_V1_GetTransactionResponse, Error>

  /// Result of a call to getTransactionHistory
  private let transactionHistoryResult: Result<Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse, Error>

  /// Initialize a new fake NetworkClient.
  ///
  /// - Parameters:
  ///   - accountInfoResult: A result which will be used to determine the behavior of getAccountInfo().
  ///   - feeResult: A result which will be used to determine the behavior of getFee().
  ///   - submitSignedTransactionResult: A result which will be used to determine the behavior of
  ///                                    submitSignedTransaction().
  ///   - transactionStatusResult: A result which will be used to determine behavior of getTransactionStatus().
  ///   - getTransactionHistoryResult: A result which will be used to determine the behavior of getTransactionHistory()
  public init(
    accountInfoResult: Result<Org_Xrpl_Rpc_V1_GetAccountInfoResponse, Error>,
    feeResult: Result<Org_Xrpl_Rpc_V1_GetFeeResponse, Error>,
    submitTransactionResult: Result<Org_Xrpl_Rpc_V1_SubmitTransactionResponse, Error>,
    transactionStatusResult: Result<Org_Xrpl_Rpc_V1_GetTransactionResponse, Error>,
    transactionHistoryResult: Result<Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse, Error>
  ) {
    self.accountInfoResult = accountInfoResult
    self.feeResult = feeResult
    self.submitTransactionResult = submitTransactionResult
    self.transactionStatusResult = transactionStatusResult
    self.transactionHistoryResult = transactionHistoryResult
  }
}

/// Conform to NetworkClient protocol, returning faked results.
extension FakeNetworkClient: NetworkClient {
  public func getAccountInfo(
    _ request: Org_Xrpl_Rpc_V1_GetAccountInfoRequest
  ) throws -> Org_Xrpl_Rpc_V1_GetAccountInfoResponse {
    switch accountInfoResult {
    case .success(let accountInfo):
      return accountInfo
    case .failure(let error):
      throw error
    }
  }

  public func getFee(_ request: Org_Xrpl_Rpc_V1_GetFeeRequest) throws -> Org_Xrpl_Rpc_V1_GetFeeResponse {
    switch feeResult {
    case .success(let fee):
      return fee
    case .failure(let error):
      throw error
    }
  }

  public func submitTransaction(
    _ request: Org_Xrpl_Rpc_V1_SubmitTransactionRequest
  ) throws -> Org_Xrpl_Rpc_V1_SubmitTransactionResponse {
    switch submitTransactionResult {
    case .success(let result):
      return result
    case .failure(let error):
      throw error
    }
  }

  public func getTransaction(
    _ request: Org_Xrpl_Rpc_V1_GetTransactionRequest
  ) throws -> Org_Xrpl_Rpc_V1_GetTransactionResponse {
    switch transactionStatusResult {
    case .success(let result):
      return result
    case .failure(let error):
      throw error
    }
  }

  public func getAccountTransactionHistory(
    _ request: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest
  ) throws -> Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse {
    switch transactionHistoryResult {
    case .success(let result):
      return result
    case .failure(let error):
      throw error
    }
  }
}
