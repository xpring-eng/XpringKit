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

  // A queue to perform networking on.
  private let networkQueue = DispatchQueue(label: "io.xpring.PayIDClient", qos: .userInitiated)

  /// Initialize a new PayID client.
  ///
  /// - Parameters:
  ///   - network: The network that addresses will be resolved on.
  ///
  /// - Note: Networks in this constructor take the form of an asset and an optional network (<asset>-<network>).
  /// For instance:
  ///   - xrpl-testnet
  ///   - xrpl-mainnet
  ///   - eth-rinkeby
  ///   - ach
  ///
  //  TODO: Link a canonical list at payid.org when available.
  public init(network: String, completionQueue: DispatchQueue = DispatchQueue.main) {
    self.network = network
  }

  /// Resolve the given PayID to an address.
  ///
  /// - Parameter payID: The PayID to resolve for an address.
  /// - Returns: An address representing the given PayID.
  public func address(for payID: String) throws -> Result<CryptoAddressDetails, PayIDError> {
    // Assign a bogus value. This will get overwritten when the asynchronous call is made.
    var result: Result<CryptoAddressDetails, PayIDError> = .failure(.unknown(error: "Unknown error."))

    // Use a semaphore to block and wait for the asynchronous call to complete.
    // Capture the resolved data in result.
    let semaphore = DispatchSemaphore(value: 0)
    self.address(for: payID, callbackQueue: self.networkQueue) { resolvedResult in
      // Capture the result of the call.
      result = resolvedResult

      // Signal to the semaphore to unblock the thread.
      semaphore.signal()
    }

    // Wait for networking to complete.
    semaphore.wait()

    return result
  }

  /// Resolve the given PayID to an address.
  ///
  /// - Parameters:
  ///   - payID: The PayID to resolve for an address.
  ///   - callbackQueue: The queue to run a callback on. Defaults to the main thread.
  ///   - completion: A closure called with the result of the operation.
  public func address(
    for payID: String,
    callbackQueue: DispatchQueue = .main,
    completion: @escaping (Result<CryptoAddressDetails, PayIDError>) -> Void
  ) {
    // Wrap completion calls in a closure which will dispatch to the callback queue.
    let queueSafeCompletion: (Result<CryptoAddressDetails, PayIDError>) -> Void = { result in
      callbackQueue.async {
        completion(result)
      }
    }

    guard let payIDComponents = PayIDUtils.parse(payID: payID) else {
      return completion(.failure(.invalidPayID(payID: payID)))
    }
    let host = payIDComponents.host
    // Drop the leading '/' in the path, Swagger adds it for us.
    let path = String(payIDComponents.path.dropFirst())

    let acceptHeaderValue = "application/\(self.network)+json"
    let client = APIClient(baseURL: "https://" + host)
    client.defaultHeaders = [
      Headers.Keys.accept: acceptHeaderValue,
      Headers.Keys.payIDVersion: Headers.Values.version
    ]

    let request = API.ResolvePayID.Request(path: path)

    client.makeRequest(request, completionQueue: self.networkQueue) { apiResponse in
      switch apiResponse.result {
      case .success(let response):
        switch response {
        case .status200(let paymentInformation):
          // With a specific network, exactly one address should be returned by a PayId lookup.
          guard paymentInformation.addresses.count == 1 else {
            let unexpectedResponseError = PayIDError.unexpectedResponse
            queueSafeCompletion(.failure(unexpectedResponseError))
            return
          }
          queueSafeCompletion(.success(paymentInformation.addresses[0].addressDetails))
        case .status404:
          queueSafeCompletion(.failure(.mappingNotFound(payID: payID, network: self.network)))
        case .status415, .status503:
          queueSafeCompletion(.failure(.unexpectedResponse))
        }

      case .failure(let error):
        queueSafeCompletion(.failure(.unknown(error: "Unknown error making request: \(error)")))
      }
    }
  }
}
