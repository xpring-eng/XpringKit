import Foundation

/// A struct representing the response format for XRP from PayID.
// TODO(keefertaylor): Generalize this to be more than XRP.
private struct XRPJSONResult: Codable {
  let address: String
}

/// Implements interaction with a PayID service.
/// - Warning: This class is experimental and should not be used in production applications.
public class PayIDClient {
  /// The URLSession to use for network requests
  private let urlSession: URLSession

  /// - Parameter urlSession: The URLSession to use for networking. Defaults to the shared session.
  public init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }

  /// Resolve the given PayID to an XRP Address.
  ///
  /// - Parameters
  ///   - payID: The PayID to resolve.
  ///   - completion: A completion block that will be called with the result of the operation.
  public func resolveToXRP(_ payID: PaymentPointer, completion: @escaping (Result<Address?, PayIDError>) -> Void) {
    guard let paymentPointer = PayIDUtils.parse(paymentPointer: payID) else {
      completion(.failure(.invalidPaymentPointer(paymentPointer: payID)))
      return
    }

    guard let url = URL(string: "https://" + paymentPointer.host + paymentPointer.path) else {
      completion(.failure(.unknown(error: "Could not formulate PayID URL from pointer \(payID)")))
      return
    }

    // TODO(keefertaylor): Generalize to add different headers.
    // TODO(keefertaylor): Add network field when spec is finalized.
    var request = URLRequest(url: url)
    request.addValue("application/xrp+json", forHTTPHeaderField: "Accept")

    self.urlSession.dataTask(with: request) { data, response, error in
      guard let urlResponse = response as? HTTPURLResponse else {
        completion(.failure(.unknown(error: "Could not formulate PayID URL from pointer \(payID)")))
        return
      }

      switch urlResponse.statusCode {
      // Response contained addresses
      case 200:
        guard
          let addressData = data,
          let decodedResponse = try? JSONDecoder().decode(XRPJSONResult.self, from: addressData)
          else {
          completion(.failure(.malformedResponse))
          return
        }

        completion(.success(decodedResponse.address))
        return
      // Address mapping not found.
      case 404:
        completion(.success(nil))
        return
      // Generic error
      default:
        var payIDErrorInfo: String?
        if let errorData = data {
          payIDErrorInfo = String(data: errorData, encoding: .utf8)
        }
        completion(.failure(.unknown(error: payIDErrorInfo)))
        return
      }
    }.resume()
  }
}
