import BigInt

/// A decorator for a XpringClient.
public protocol XpringClientDecorator {
  /// Get the balance for the given address.
  ///
  /// - Parameter address: The X-Address to retrieve the balance for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: An unsigned integer containing the balance of the address in drops.
  func getBalance(for address: Address) throws -> BigUInt

  /// Retrieve the transaction status for a given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationAddress: The X-Address which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  func send(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash
}
