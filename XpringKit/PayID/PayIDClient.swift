import Alamofire
import Foundation

/// Implements interaction with a PayID service.
/// - Warning:  This class is experimental and should not be used in production applications.
public class PayIDClient: PayIDClientProtocol {
  /// The network this PayID client resolves on.
  public let network: XRPLNetwork

  /// Initialize a new PayIDClient.
  ///
  /// - Parameter network: The network that addresses will be resolved on.
  public init(network: XRPLNetwork) {
    self.network = network
  }

  /// Resolve the given PayID to an XRP Address.
  ///
  /// - Note: The returned value will always be in an X-Address format.
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Returns: An XRP address representing the given PayID.
  // TODO(keefertaylor): Make this API synchronous to mirror functionality provided by ILP / XRP.
  public func xrpAddress(for payID: String, completion: @escaping (Swift.Result<String, PayIDError>) -> Void) {
    guard let paymentPointer = PayIDUtils.parse(payID: payID) else {
      return completion(.failure(.invalidPaymentPointer(paymentPointer: payID)))
    }

    let path = String(paymentPointer.path.dropFirst())
    let host = paymentPointer.host
    let acceptHeaderValue = "application/xrpl-\(self.network.rawValue)+json"

    let client = APIClient(baseURL: "https://" + host)
    client.defaultHeaders = [ "Accept": acceptHeaderValue ]

    let request = API.ResolvePayID.Request(path: path)
    client.makeRequest(request) { apiResponse in
      switch apiResponse.result {
      case .success(let response):
        switch response {
        case .status200(let paymentInformation):
          completion(.success(paymentInformation.addressDetails.address))
        case .status404:
          completion(.failure(PayIDError.mappingNotFound(paymentPointer: payID, network: self.network)))
        case .status415:
          // TODO(keefertaylor): Provide a more descriptive error.
          completion(.failure(PayIDError.unknown(error: "Error: HTTP Status 415")))
        case .status503:
          // TODO(keefertaylor): Provide a more descriptive error.
          completion(.failure(PayIDError.unknown(error: "Error: HTTP Status 503")))
        }
      case .failure(let error):
        completion(.failure(PayIDError.unknown(error: "Unknown error making requests: \(error)")))
      }
    }
  }
}
