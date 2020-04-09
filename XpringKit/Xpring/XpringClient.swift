import Foundation

/// Composes interactions of Xpring services.
public class XpringClient {
  /// A PayIDClient used to interact with the Pay ID protocol.
  private let payIDClient: PayIDClient

  /// An XRPClient used to interact with the XRP Ledger protocol.
  private let xrpClient: XRPClient

  /// Create a new XpringClient.
  ///
  /// - Parameters:
  ///   - payIDClient A Pay ID Client used to interact with the Pay ID protocol.
  ///   - xrpClient An XRP Client used to interact with the XRP Ledger protocol.
  public init(payIDClient: PayIDClient, xrpClient: XRPClient) {
    // TODO(keefertaylor): Validate that components are attached to the same network.
    self.payIDClient = payIDClient
    self.xrpClient = xrpClient
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationPaymentPointer: The payment pointer which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  public func send(
    _ amount: UInt64,
    to destinationPayID: PaymentPointer,
    from sourceWallet: Wallet
  ) throws -> TransactionHash {
    // Use a dispatch group to make this method behave synchronously.
    // TODO(keefertaylor): Clean this up when we have a synchronous call for resolving Pay IDs.
    let resolveDispatchGroup = DispatchGroup()
    resolveDispatchGroup.enter()
    var destinationResult: Result<Address, PayIDError> = .failure(.unknown(error: "Unknown"))
    self.payIDClient.xrpAddress(for: destinationPayID) { result in
      defer {
        resolveDispatchGroup.leave()
      }
      destinationResult = result
    }
    resolveDispatchGroup.wait()

    // Send XRP to the resolved destination or throw the error if there was an error during resolution.
    switch destinationResult {
    case .failure(let error):
      throw error
    case.success(let address):
      return try self.xrpClient.send(amount, to: address, from: sourceWallet)
    }
  }
}
