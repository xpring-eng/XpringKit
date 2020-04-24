import Foundation
import XpringKit

/// Fakes a PayID client.
public class FakePayIDClient: PayIDClientProtocol {
  /// Results from method calls.
  private let addressResult: Result<String, PayIDError>

  /// Initialize a new fake Pay ID client.
  ///
  /// - Parameter addressResult: The result that will be returned from calls to `xrpAddress(for:completion:)`.
  public init(addressResult: Result<String, PayIDError>) {
    self.addressResult = addressResult
  }

  public func xrpAddress(for payID: String, completion: @escaping (Result<String, PayIDError>) -> Void) {
    completion(addressResult)
  }
}
