/// An interface into the Xpring Platform.
public class XpringClient {
  private let decoratedClient: XpringClientDecorator

  /// Initialize a new XpringClient.
  ///
  /// - Parameter grpcURL: A remote URL for a rippled gRPC service.
  public init(grpcURL: String) {
    let defaultClient = LegacyDefaultXpringClient(grpcURL: grpcURL)
    decoratedClient = ReliableSubmissionXpringClient(decoratedClient: defaultClient)
  }

  /// Get the balance for the given address.
  ///
  /// - Parameter address: The X-Address to retrieve the balance for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: An unsigned integer containing the balance of the address in drops.
  public func getBalance(for address: Address) throws -> UInt64 {
    return try decoratedClient.getBalance(for: address)
  }

  /// Retrieve the transaction status for a given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return try decoratedClient.getTransactionStatus(for: transactionHash)
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationAddress: The X-Address which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  public func send(_ amount: UInt64, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    return try decoratedClient.send(amount, to: destinationAddress, from: sourceWallet)
  }
}
