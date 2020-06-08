import Alamofire
import Foundation

/// Implements interaction with a PayID service.
/// - Warning:  This class is experimental and should not be used in production applications.
public class PayIDClient {
  private enum Headers {
    public enum Keys {
      public static let accept = "Accept"
      public static let payIDVersion = "PayID-Version"
    }

    public enum Values {
      public static let version = "1.0"
    }
  }

  /// The network this PayID client resolves on.
  private let network: String

  /// The `SessionManager` for network requests.
  private let sessionManager: SessionManager

  /// Initialize a new PayID client.
  ///
  /// - Parameters:
  ///   - network: The network that addresses will be resolved on.
  ///   - sessionManager: A SessionManager which will administer network 
  ///                     requests. Defaults to the default SessionManager.
  ///
  /// - Note: Networks in this constructor take the form of an asset and an optional network (<asset>-<network>).
  /// For instance:
  ///   - xrpl-testnet
  ///   - xrpl-mainnet
  ///   - eth-rinkeby
  ///   - ach
  ///
  //  TODO: Link a canonical list at payid.org when available.
  public init(network: String, sessionManager: SessionManager = .default) {
    self.network = network
    self.sessionManager = sessionManager
  }

  /// Resolve the given PayID to an address.
  ///
  /// - Parameter payID: The PayID to resolve for an address.
  /// - Parameter completion: A closure called with the result of the operation.
  /// - Returns: An address representing the given PayID.
  // TODO(keefertaylor): Make this API synchronous to mirror functionality provided by ILP / XRP.
  public func address(
    for payID: String,
    completion: @escaping (Swift.Result<CryptoAddressDetails, PayIDError>) -> Void
  ) {
    guard let payIDComponents = PayIDUtils.parse(payID: payID) else {
      return completion(.failure(.invalidPayID(payID: payID)))
    }
    let host = payIDComponents.host
    // Drop the leading '/' in the path, Swagger adds it for us.
    let path = String(payIDComponents.path.dropFirst())

    let acceptHeaderValue = "application/\(self.network)+json"
    let client = APIClient(baseURL: "https://" + host, sessionManager: self.sessionManager)
    client.defaultHeaders = [
      Headers.Keys.accept: acceptHeaderValue,
      Headers.Keys.payIDVersion: Headers.Values.version
    ]

    let request = API.ResolvePayID.Request(path: path)

    client.makeRequest(request) { apiResponse in
      switch apiResponse.result {
      case .success(let response):
        switch response {
        case .status200(let paymentInformation):
          // With a specific network, exactly one address should be returned by a PayId lookup.
          guard paymentInformation.addresses.count == 1 else {
            let unexpectedResponseError = PayIDError.unexpectedResponse
            completion(.failure(unexpectedResponseError))
            return
          }
          completion(.success(paymentInformation.addresses[0].addressDetails))
        case .status404:
          completion(.failure(.mappingNotFound(payID: payID, network: self.network)))
        case .status415, .status503:
          completion(.failure(.unexpectedResponse))
        }

      case .failure(let error):
        completion(.failure(.unknown(error: "Unknown error making request: \(error)")))
      }
    }
  }
}
