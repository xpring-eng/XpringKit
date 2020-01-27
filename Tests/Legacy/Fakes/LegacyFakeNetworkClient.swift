import XpringKit

/// A fake network client which faekse calls.
public class LegacyFakeNetworkClient {
  /// Result of a call to getAccountInfo
  private let accountInfoResult: Result<Io_Xpring_AccountInfo, Error>
  
  /// Result of a call to getFee
  private let feeResult: Result<Io_Xpring_Fee, Error>
  
  /// Result of a call to submitSignedTransaction.
  private let submitSignedTransactionResult: Result<Io_Xpring_SubmitSignedTransactionResponse, Error>
  
  /// Result of a call to getLatestValidatedLedgerSequence.
  private let latestValidatedLedgerSequenceResult: Result<Io_Xpring_LedgerSequence, Error>
  
  /// Result of a call to getTransactionStatus.
  private let transactionStatusResult: Result<Io_Xpring_TransactionStatus, Error>
  
  /// Initialize a new fake NetworkClient.
  ///
  /// - Parameters:
  ///   - accountInfoResult: A result which will be used to determine the behavior of getAccountInfo().
  ///   - feeResult: A result which will be used to determine the behavior of getFee().
  ///   - submitSignedTransactionResult: A result which will be used to determine the behavior of submitSignedTransaction().
  ///   - latestValidatedLedgerSequenceResult: A result which will be used to determine behavior of getLatestValidatedLedgerSequence().
  ///   - transactionStatusResult: A result which will be used to determine behavior of getTransactionStatus().
  public init(
    accountInfoResult: Result<Io_Xpring_AccountInfo, Error>,
    feeResult: Result<Io_Xpring_Fee, Error>,
    submitSignedTransactionResult: Result<Io_Xpring_SubmitSignedTransactionResponse, Error>,
    latestValidatedLedgerSequenceResult: Result<Io_Xpring_LedgerSequence, Error>,
    transactionStatusResult: Result<Io_Xpring_TransactionStatus, Error>
  ) {
    self.accountInfoResult = accountInfoResult
    self.feeResult = feeResult
    self.submitSignedTransactionResult = submitSignedTransactionResult
    self.latestValidatedLedgerSequenceResult = latestValidatedLedgerSequenceResult
    self.transactionStatusResult = transactionStatusResult
  }
}

/// Conform to NetworkClient protocol, returning faked results.
extension LegacyFakeNetworkClient: LegacyNetworkClient {
  public func getAccountInfo(_ request: Io_Xpring_GetAccountInfoRequest) throws -> Io_Xpring_AccountInfo {
    switch accountInfoResult {
    case .success(let accountInfo):
      return accountInfo
    case .failure(let error):
      throw error
    }
  }
  
  public func getFee(_ request: Io_Xpring_GetFeeRequest) throws -> Io_Xpring_Fee {
    switch feeResult {
    case .success(let fee):
      return fee
    case .failure(let error):
      throw error
    }
  }
  
  public func submitSignedTransaction(_ request: Io_Xpring_SubmitSignedTransactionRequest) throws -> Io_Xpring_SubmitSignedTransactionResponse {
    switch submitSignedTransactionResult {
    case .success(let result):
      return result
    case .failure(let error):
      throw error
    }
  }
  
  public func getLatestValidatedLedgerSequence(_ request: Io_Xpring_GetLatestValidatedLedgerSequenceRequest) throws -> Io_Xpring_LedgerSequence {
    switch latestValidatedLedgerSequenceResult {
    case .success(let result):
      return result
    case .failure(let error):
      throw error
    }
  }
  
  public func getTransactionStatus(_ request: Io_Xpring_GetTransactionStatusRequest) throws -> Io_Xpring_TransactionStatus {
    switch transactionStatusResult {
    case .success(let result):
      return result
    case .failure(let error):
      throw error
    }
  }
}
