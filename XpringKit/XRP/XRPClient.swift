/// An interface into the XRP Ledger.
public class XRPClient: XRPClientProtocol {
  /// The XRPL Network of the node that this client is communicating with
  public let network: XRPLNetwork

  private let decoratedClient: XRPClientDecorator

  /// Initialize a new XRPClient.
  ///
  /// - Parameters:
  ///   - grpcURL: A remote URL for a rippled gRPC service.
  ///   - network: The network this XRPClient is connecting to.
  public init(grpcURL: String, network: XRPLNetwork) {
    let defaultClient = DefaultXRPClient(grpcURL: grpcURL)
    decoratedClient = ReliableSubmissionXRPClient(decoratedClient: defaultClient)

    self.network = network
  }

  /// Get the balance for the given address.
  ///
  /// - Parameter address: The X-Address to retrieve the balance for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: An unsigned integer containing the balance of the address in drops.
  public func getBalance(for address: Address) throws -> UInt64 {
    return try decoratedClient.getBalance(for: address)
  }

  /// Retrieve the payment status for a Payment given transaction hash.
  ///
  /// - Note: This method will only work for Payment type transactions which do not have the tf_partial_payment
  ///         attribute set
  ///.
  /// - SeeAlso: https://xrpl.org/payment.html#payment-flags
  ///
  /// - Parameter transactionHash The hash of the transaction.
  /// - Returns: The status of the given transaction.
  public func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return try self.decoratedClient.paymentStatus(for: transactionHash)
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationAddress: The X-Address which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  public func send(
    _ amount: UInt64,
    to destinationAddress: Address,
    from sourceWallet: Wallet
  ) throws -> TransactionHash {
    return try decoratedClient.send(amount, to: destinationAddress, from: sourceWallet)
  }

  /// Check if an address exists on the XRP Ledger
  ///
  /// - Parameter address: The address to check the existence of.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A boolean if the account is on the blockchain.
  public func accountExists(for address: Address) throws -> Bool {
    return try decoratedClient.accountExists(for: address)
  }

  /// Return the history of payments for the given account.
  ///
  /// - Note: This method only works for payment type transactions, see: https://xrpl.org/payment.html
  /// - Note: This method only returns the history that is contained on the remote node, which may not contain a full
  ///         history of the network. 
  ///
  /// - Parameter address: The address (account) for which to retrive payment history.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: An array of transactions associated with the account.
  public func paymentHistory(for address: Address) throws -> [XRPTransaction] {
    return try decoratedClient.paymentHistory(for: address)
  }
}
