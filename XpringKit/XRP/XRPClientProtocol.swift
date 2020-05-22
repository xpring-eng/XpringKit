/// An interface into the XRP Platform.
public protocol XRPClientProtocol {
  /// The XRPL Network of the node that this client is communicating with
  var network: XRPLNetwork { get }

  /// Get the balance for the given address.
  ///
  /// - Parameter address: The X-Address to retrieve the balance for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: An unsigned integer containing the balance of the address in drops.
  func getBalance(for address: XRPAddress) throws -> UInt64

  /// Retrieve the payment status for a Payment given transaction hash.
  ///
  /// - Note: This method will only work for Payment type transactions which do not have the tf_partial_payment
  ///         attribute set.
  /// - SeeAlso: https://xrpl.org/payment.html#payment-flags
  ///
  /// - Parameter transactionHash The hash of the transaction.
  /// - Returns: The status of the given transaction.
  func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationAddress: The X-Address which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  func send(_ amount: UInt64, to destinationAddress: XRPAddress, from sourceWallet: Wallet) throws -> TransactionHash

  /// Check if an address exists on the XRP Ledger
  ///
  /// - Parameter address: The address to check the existence of.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A boolean if the account is on the blockchain.
  func accountExists(for address: XRPAddress) throws -> Bool

  /// Return the history of payments for the given account.
  ///
  /// - Note: This method only works for payment type transactions, see: https://xrpl.org/payment.html
  /// - Note: This method only returns the history that is contained on the remote node, which may not contain a full
  ///         history of the network.
  ///
  /// - Parameter address: The address (account) for which to retrieve payment history.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: An array of transactions associated with the account.
  func paymentHistory(for address: XRPAddress) throws -> [XRPTransaction]
}
