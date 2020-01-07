/// A client which can make requests to the Xpring Network.
public protocol NetworkClient {
    /// Get an `AccountInfo` object.
    ///
    /// - Parameter request: Request parameters for an `AccountInfo`.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: An `AccountInfo` object that corresponds to the request.
    func getAccountInfo(_ request: Rpc_V1_GetAccountInfoRequest) throws -> Rpc_V1_GetAccountInfoResponse
    
    //// Get the fee to commit a transaction to the XRP Ledger.
    ///
    /// - Parameter request: Request parameters for a fee.
    ///	- Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: A `Fee` object that corresponds to the request.
    func getFee(_ request: Rpc_V1_GetFeeRequest) throws -> Rpc_V1_Fee
    
    /// Submit a signed transaction for inclusion in the XRP Ledger.
    ///
    /// - Parameter request: Request parameters for submitting a signed transaction.
    ///	- Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: A response from the ledger acknowledging the transaction submission.
    func submitTransaction(_ request: Rpc_V1_SubmitTransactionRequest) throws -> Rpc_V1_SubmitTransactionResponse
    
    /// Retrieve transaction for a given transaction hash from the XRP Ledger.
    ///
    /// - Parameter request: Request parameters for retrieving transaction status.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The `Transaction`  for the transactioon.
    func getTx(_ request: Rpc_V1_GetTxRequest) throws -> Rpc_V1_GetTxResponse
}
