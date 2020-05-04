import Foundation
import XpringKit

/// Fakes a PayID client.
public class FakePayIDClient: PayIDClientProtocol {
  public let network: XRPLNetwork

  /// Results from method calls.
  private let addressResult: Result<String, PayIDError>

  /// Initialize a new fake Pay ID client.
  ///
  /// - Parameter addressResult: The result that will be returned from calls to `xrpAddress(for:completion:)`.
  public init(network: XRPLNetwork = .test, addressResult: Result<String, PayIDError>) {
    self.addressResult = addressResult
    self.network = network
  }

  public func xrpAddress(
    for payID: String,
    completion: @escaping (Result<String, PayIDError>) -> Void
  ) {
    completion(self.addressResult)
  }
}
