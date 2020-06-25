import Foundation

/// Composes interactions of Xpring services.
public class XpringClient {
  /// An XRPPayIDClient used to interact with the Pay ID protocol.
  private let payIDClient: XRPPayIDClientProtocol

  /// An XRPClient used to interact with the XRP Ledger protocol.
  private let xrpClient: XRPClientProtocol

  /// A queue to perform async operations on.
  private let asyncQueue = DispatchQueue(label: "io.xpring.XpringClient", qos: .userInitiated)

  /// Create a new XpringClient.
  ///
  /// - Parameters:
  ///   - payIDClient An XRP Pay ID Client used to interact with the Pay ID protocol.
  ///   - xrpClient An XRP Client used to interact with the XRP Ledger protocol.
  public init(payIDClient: XRPPayIDClientProtocol, xrpClient: XRPClientProtocol) throws {
    guard payIDClient.xrplNetwork == xrpClient.network else {
      throw XpringError.mismatchedNetworks
    }

    self.payIDClient = payIDClient
    self.xrpClient = xrpClient
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationPayID: The PayID which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Returns: A result containing the transaction hash if successful.
  public func send(
    _ amount: UInt64,
    to destinationPayID: String,
    from sourceWallet: Wallet
  ) -> Result<TransactionHash, Error> {
    let result = self.payIDClient.xrpAddress(for: destinationPayID)
    switch result {
    case .success(let address):
      do {
        let transactionHash = try self.xrpClient.send(amount, to: address, from: sourceWallet)
        return .success(transactionHash)
      } catch {
        return .failure(error)
      }
    case .failure(let payIDError):
      return .failure(payIDError)
    }
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationPayID: The PayID which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  ///    - callbackQueue: The queue to run a callback on. Defaults to the main thread.
  ///    - completion: A completion handler with the result of the operation.
  public func send(
    _ amount: UInt64,
    to destinationPayID: String,
    from sourceWallet: Wallet,
    callbackQueue: DispatchQueue = .main,
    completion: @escaping (Result<TransactionHash, Error>) -> Void
  ) {
    let queueSafeCompletion: (Result<TransactionHash, Error>) -> Void = { result in
      callbackQueue.async {
        completion(result)
      }
    }

    asyncQueue.async {
      let result = self.send(amount, to: destinationPayID, from: sourceWallet)
      queueSafeCompletion(result)
    }
  }
}
