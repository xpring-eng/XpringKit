import Alamofire
import Foundation

/// Implements interaction with a PayID service.
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

  /// A queue to perform networking on.
  private let networkQueue = DispatchQueue(label: "io.xpring.PayIDClient", qos: .userInitiated)

  /// The `SessionManager` for network requests.
  private let sessionManager: SessionManager

  /// Initialize a new PayID client.
  ///
  /// - Parameters:
  ///   - sessionManager: A SessionManager which will administer network 
  ///                     requests. Defaults to the default SessionManager.
  public init(sessionManager: SessionManager = .default) {
    self.sessionManager = sessionManager
  }

  /// Resolve the given PayID to an address on the given network.
  ///
  /// - SeeAlso: https://docs.payid.org/payid-headers
  ///
  /// - Parameters:
  ///   - payID: The PayID to resolve for an address.
  ///   - network: The network to resolve the PayID on.
  /// - Returns: An address representing the given PayID.
  public func cryptoAddress(for payID: String, on network: String) -> Swift.Result<CryptoAddressDetails, PayIDError> {
    // Assign a bogus value. This will get overwritten when the asynchronous call is made.
    var result: Swift.Result<CryptoAddressDetails, PayIDError> = .failure(.unknown(error: "Unknown error."))

    // Use a semaphore to block and wait for the asynchronous call to complete.
    // Capture the resolved data in result.
    let semaphore = DispatchSemaphore(value: 0)
    self.cryptoAddress(for: payID, on: network, callbackQueue: self.networkQueue) { resolvedResult in
      // Capture the result of the call.
      result = resolvedResult

      // Signal to the semaphore to unblock the thread.
      semaphore.signal()
    }

    // Wait for networking to complete.
    semaphore.wait()

    return result
  }

  /// Resolve all addresses for the given PayID.
  ///
  /// - Parameter payID: The PayID to resolve for an address.
  /// - Returns: All addresses for the PayID.
  public func allAddresses(for payID: String) -> Swift.Result<[PayIDAddress], PayIDError> {
    // Assign a bogus value. This will get overwritten when the asynchronous call is made.
    var result: Swift.Result<[PayIDAddress], PayIDError> = .failure(.unknown(error: "Unknown error."))

    // Use a semaphore to block and wait for the asynchronous call to complete.
    // Capture the resolved data in result.
    let semaphore = DispatchSemaphore(value: 0)
    self.allAddresses(for: payID, callbackQueue: self.networkQueue) { resolvedResult in
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
  ///   - network: The network to resolve the PayID on.  
  ///   - callbackQueue: The queue to run a callback on. Defaults to the main thread.
  ///   - completion: A closure called with the result of the operation.
  public func cryptoAddress(
    for payID: String,
    on network: String,
    callbackQueue: DispatchQueue = .main,
    completion: @escaping (Swift.Result<CryptoAddressDetails, PayIDError>) -> Void
  ) {
    // Wrap completion calls in a closure which will dispatch to the callback queue.
    let queueSafeCompletion: (Swift.Result<CryptoAddressDetails, PayIDError>) -> Void = { result in
      callbackQueue.async {
        completion(result)
      }
    }

    self.addresses(for: payID, on: network, callbackQueue: callbackQueue) { result in
      switch result {
      case .success(let addresses):
        // With a specific network, exactly one address should be returned by a PayId lookup.
        guard addresses.count == 1 else {
          let unexpectedResponseError = PayIDError.unexpectedResponse
          queueSafeCompletion(.failure(unexpectedResponseError))
          return
        }
        queueSafeCompletion(.success(addresses[0].addressDetails))
      case .failure(let error):
        queueSafeCompletion(.failure(error))
      }
    }
  }

  /// Resolve all addresses for the given PayID.
  ///
  /// - Parameters:
  ///   - payID: The PayID to resolve for an address.
  ///   - callbackQueue: The queue to run a callback on. Defaults to the main thread.
  ///   - completion: A closure called with the result of the operation.
  public func allAddresses(
    for payID: String,
    callbackQueue: DispatchQueue = .main,
    completion: @escaping (Swift.Result<[PayIDAddress], PayIDError>) -> Void
  ) {
    // Wrap completion calls in a closure which will dispatch to the callback queue.
    let queueSafeCompletion: (Swift.Result<[PayIDAddress], PayIDError>) -> Void = { result in
      callbackQueue.async {
        completion(result)
      }
    }

    self.addresses(for: payID, on: "payid", callbackQueue: callbackQueue) { result in
      switch result {
      case .success(let addresses):
        // With a specific network, exactly one address should be returned by a PayId lookup.
        queueSafeCompletion(.success(addresses))
      case .failure(let error):
        queueSafeCompletion(.failure(error))
      }
    }
  }

  private func addresses(
    for payID: String,
    on network: String,
    callbackQueue: DispatchQueue = .main,
    completion: @escaping (Swift.Result<[PayIDAddress], PayIDError>) -> Void
  ) {
    // Wrap completion calls in a closure which will dispatch to the callback queue.
    let queueSafeCompletion: (Swift.Result<[PayIDAddress], PayIDError>) -> Void = { result in
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

    let acceptHeaderValue = "application/\(network)+json"
    let client = APIClient(baseURL: "https://" + host, sessionManager: self.sessionManager)
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
          queueSafeCompletion(.success(paymentInformation.addresses))
        case .status404:
          queueSafeCompletion(.failure(.mappingNotFound(payID: payID, network: network)))
        case .status415, .status503:
          queueSafeCompletion(.failure(.unexpectedResponse))
        }

      case .failure(let error):
        queueSafeCompletion(.failure(.unknown(error: "Unknown error making request: \(error)")))
      }
    }
  }
}
