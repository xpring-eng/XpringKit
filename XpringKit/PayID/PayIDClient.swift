import Alamofire
import Foundation

/// Implements interaction with a PayID service.
/// - Warning:  This class is experimental and should not be used in production applications.
public class PayIDClient {
  /// The network this PayID client resolves on.
  private let network: XRPLNetwork

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

    var endpoint = "/{host}/{path}"

    let hostPreEscape = "\(host)"
    let hostPostEscape = hostPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    endpoint = endpoint.replacingOccurrences(of: "{host}", with: hostPostEscape, options: .literal, range: nil)

    let pathPreEscape = "\(path)"
    let pathPostEscape = pathPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    endpoint = endpoint.replacingOccurrences(of: "{path}", with: pathPostEscape, options: .literal, range: nil)

    let URLString = SwaggerClientAPI.basePath + endpoint
    let parameters: [String: Any]? = nil

    let url = URLComponents(string: URLString)

    let requestBuilder: RequestBuilder<PaymentInformation>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()
    let request = requestBuilder.init(
      method: "GET",
      URLString: (url?.string ?? URLString),
      parameters: parameters,
      isBody: false
    ).addHeader(
      name: "Accept",
      value: acceptHeaderValue
    )

    request.execute { response, error in
      if
        let response = response,
        let paymentInformation = response.body {
        completion(.success(paymentInformation.addressDetails.address))
      } else if
        let errorResponse = error as? ErrorResponse,
        case let .error(code, _, underlyingError) = errorResponse,
        let alamoFireError = underlyingError as? AFError
      {
        // Mapping not found
        if code == 404 {
          let mappingError = PayIDError.mappingNotFound(paymentPointer: payID, network: self.network)
          completion(.failure(mappingError))
          return
        }
        completion(.failure(.unknown(error: alamoFireError.underlyingError.debugDescription)))
      } else {
        completion(.failure(.unknown(error: nil)))
      }
    }
  }
}
