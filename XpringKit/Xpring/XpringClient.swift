import Foundation

/// Composes interactions of Xpring services.
public class XpringClient {
  /// An XRP PayIDClient used to interact with the Pay ID protocol.
  private let payIDClient: XRPPayIDClientProtocol

  /// An XRPClient used to interact with the XRP Ledger protocol.
  private let xrpClient: XRPClientProtocol

  /// Create a new XpringClient.
  ///
  /// - Parameters:
  ///   - payIDClient An XRP Pay ID Client used to interact with the Pay ID protocol.
  ///   - xrpClient An XRP Client used to interact with the XRP Ledger protocol.
  public init(payIDClient: PayIDClientProtocol, xrpClient: XRPClientProtocol) throws {
    guard payIDClient.network == xrpClient.network else {
      throw XpringError.mismatchedNetworks
    }

    self.payIDClient = payIDClient
    self.xrpClient = xrpClient
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationPaymentPointer: The payment pointer which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  ///    - completion: A completion handler with the result of the operation.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  // TODO(keefertaylor): Make this API synchronous to mirror functionality provided by ILP / XRP.
  public func send(
    _ amount: UInt64,
    to destinationPayID: PaymentPointer,
    from sourceWallet: Wallet,
    completion: @escaping (Result<TransactionHash, Error>) -> Void
  ) {
    self.payIDClient.xrpAddress(for: destinationPayID) { [weak self] result in
      guard let self = self else {
        return
      }

      switch result {
      case .success(let address):
        do {
          let transactionHash = try self.xrpClient.send(amount, to: address, from: sourceWallet)
          completion(.success(transactionHash))
        } catch {
          completion(.failure(error))
        }
      case .failure(let payIDError):
        completion(.failure(payIDError))
      }
    }
  }
}
