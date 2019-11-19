/// A client which can make requests to the Xpring Network.
public protocol NetworkClient {
  /// Get an `AccountInfo` object.
  ///
  /// - Parameter request: Request parameters for an `AccountInfo`.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: An `AccountInfo` object that corresponds to the request.
  func getAccountInfo(_ request: Io_Xpring_GetAccountInfoRequest) throws -> Io_Xpring_AccountInfo
  
  //// Get the fee to commit a transaction to the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for a fee.
  ///	- Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Fee` object that corresponds to the request.
  func getFee(_ request: Io_Xpring_GetFeeRequest) throws -> Io_Xpring_Fee
  
  /// Submit a signed transaction for inclusion in the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for submitting a signed transaction.
  ///	- Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A response from the ledger acknowledging the transaction submission.
  func submitSignedTransaction(_ request: Io_Xpring_SubmitSignedTransactionRequest) throws -> Io_Xpring_SubmitSignedTransactionResponse
  
  /// Retrieve the latest validated ledger sequence from the XRP Ledger.
  ///
  /// - Parameter request: Request parameters for retrieving the latest validated ledger sequence.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A  `LedgerSequence` object which contains the index.
  func getLatestValidatedLedgerSequence(_ request: Io_Xpring_GetLatestValidatedLedgerSequenceRequest) throws -> Io_Xpring_LedgerSequence
}
