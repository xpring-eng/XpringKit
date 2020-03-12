public protocol PayIDClientProtocol {
  func resolveToXRPAddress(payID: PaymentPointer, completion: @escaping (Result<Address?, PayIDError>) -> Void)
}

public protocol XRPClientProtocol {
  /// Get the balance for the given address.
  ///
  /// - Parameter address: The X-Address to retrieve the balance for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: An unsigned integer containing the balance of the address in drops.
  func getBalance(for address: Address) throws -> UInt64;

  /// Retrieve the transaction status for a given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus;

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationAddress: The X-Address which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  func send(_ amount: UInt64, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash;

  /// Check if an address exists on the XRP Ledger
  ///
  /// - Parameter address: The address to check the existence of.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A boolean if the account is on the blockchain.
  func accountExists(for address: Address) throws -> Bool;
}

public enum XpringError: Error {
  case unableToResolvePayID(payID: String)
  case unknown(description: String)
}


public class XpringClient {
  public let payIDClient: PayIDClientProtocol
  public let xrpClient: XRPClientProtocol

  public init(payIDClient: PayIDClientProtocol, xrpClient: XRPClientProtocol) {
    self.payIDClient = payIDClient
    self.xrpClient = xrpClient
  }

  /// Send XRP to a PayID.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationPayID: The Pay ID which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  ///       - completion:  A block called with the result of the operation.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  public func send(
    _ amount: UInt64, to payID: PaymentPointer, from sourceWallet: Wallet, completion: @escaping (Result<TransactionHash, XpringError>) -> Void) {
    self.payIDClient.resolveToXRPAddress(payID: payID) { [weak self] result in
      guard let self = self else {
        return
      }

      switch result {
      case .success(let address):
        guard let address = address else {
          completion(.failure(.unableToResolvePayID(payID: payID)))
          return
        }


        let transactionHash = self.xrpClient.send(amount, to: address, from: wallet)
        completion(.success(transactionHash))
      case .failure(let error):
        completion(.failure(.unknown))
      }

    }



  }


}
