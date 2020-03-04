/// A client which can make requests to the Xpring Network.
public protocol NetworkClient {
  /// Get account info for an account.
  ///
  /// - Parameter request: Request parameters.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: An `AccountInfo` object that corresponds to the request.
  func getAccountInfo(_ request: Org_Xrpl_Rpc_V1_GetAccountInfoRequest) throws -> Org_Xrpl_Rpc_V1_GetAccountInfoResponse

  //// Get the fee to commit a transaction to the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for a fee.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Fee` object that corresponds to the request.
  func getFee(_ request: Org_Xrpl_Rpc_V1_GetFeeRequest) throws -> Org_Xrpl_Rpc_V1_GetFeeResponse

  /// Submit a signed transaction for inclusion in the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for submitting a signed transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A response from the ledger acknowledging the transaction submission.
  func submitTransaction(_ request: Org_Xrpl_Rpc_V1_SubmitTransactionRequest) throws -> Org_Xrpl_Rpc_V1_SubmitTransactionResponse

  /// Retrieve transaction status for a given transaction hash from the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for retrieving transaction status.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `TransactionStatus`  for the transactioon.
  func getTransaction(_ request: Org_Xrpl_Rpc_V1_GetTransactionRequest) throws -> Org_Xrpl_Rpc_V1_GetTransactionResponse

  /// Retrieve account transaction history for an address on the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for retrieving transaction history.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A response contiaining transaction history and metadata.
  func getAccountTransactionHistory(
    _ request: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest
  ) throws -> Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse
}
