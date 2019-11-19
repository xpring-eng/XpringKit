import XpringKit

/// A fake network client which faekse calls.
public class FakeNetworkClient {
  /// Result of a call to getAccountInfo
  private let accountInfoResult: Result<Io_Xpring_AccountInfo, Error>
  
  /// Result of a call to getFee
  private let feeResult: Result<Io_Xpring_Fee, Error>
  
  /// Result of a call to submitSignedTransaction.
  private let submitSignedTransactionResult: Result<Io_Xpring_SubmitSignedTransactionResponse, Error>
  
  /// Result of a call to getLatestValidatedLedgerSequence.
  private let latestValidatedLedgerSequenceResult: Result<Io_Xpring_LedgerSequence, Error>
  
  /// Initialize a new fake NetworkClient.
  ///
  /// - Parameter accountInfoResult: A result which will be used to determine the behavior of getAccountInfo().
  /// - Parameter feeResult: A result which will be used to determine the behavior of getFee().
  /// - Parameter submitSignedTransactionResult: A result which will be used to determine the behavior of submitSignedTransaction().
  /// - Parameter latestValidatedLedgerSequenceResult: A result which will be used to determine behavior of getLatestValidatedLedgerSequence().
  public init(
    accountInfoResult: Result<Io_Xpring_AccountInfo, Error>,
    feeResult: Result<Io_Xpring_Fee, Error>,
    submitSignedTransactionResult: Result<Io_Xpring_SubmitSignedTransactionResponse, Error>,
    latestValidatedLedgerSequenceResult: Result<Io_Xpring_LedgerSequence, Error>
  ) {
    self.accountInfoResult = accountInfoResult
    self.feeResult = feeResult
    self.submitSignedTransactionResult = submitSignedTransactionResult
    self.latestValidatedLedgerSequenceResult = latestValidatedLedgerSequenceResult
  }
}

/// Conform to NetworkClient protocol, returning faked results.
extension FakeNetworkClient: NetworkClient {
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
}
