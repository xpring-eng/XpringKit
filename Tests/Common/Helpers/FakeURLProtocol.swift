import Foundation

/// A fake implementation of URLProtocol.
/// This class is heavily adapted from https://jeroenscode.com/mocking-alamofire/.
/// - SeeAlso: https://developer.apple.com/documentation/foundation/urlprotocol
final class FakeURLProtocol: URLProtocol {
  /// Types of responses.
  enum ResponseType {
    // An error response and associated value.
    case error(Error)

    // A success response type, with the given response and ASCII encoded data.
    case success(HTTPURLResponse, String)
  }

  /// A static stored response that will be returned for all network requests.
  static var responseType: ResponseType!

  private lazy var session: URLSession = {
    let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  private(set) var activeTask: URLSessionTask?

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override class func requestIsCacheEquivalent(_ leftHandSide: URLRequest, to rightHandSide: URLRequest) -> Bool {
    return false
  }

  override func startLoading() {
    activeTask = session.dataTask(with: request.urlRequest!)
    activeTask?.cancel()
  }

  override func stopLoading() {
    activeTask?.cancel()
  }
}

// MARK: - URLSessionDataDelegate

/// Conform `FakeURLProtocol` to `URLSessionDataDelegate`.
/// - SeeAlso: https://developer.apple.com/documentation/foundation/urlsessiondatadelegate
extension FakeURLProtocol: URLSessionDataDelegate {
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
  }

  /// Mock results of a load from a URL to return the static storage in FakeURLProtocol.
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    switch FakeURLProtocol.responseType {
    case .error(let error)?:
      client?.urlProtocol(self, didFailWithError: error)
    case .success(let response, let asciiString)?:
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: asciiString.data(using: .utf8)!)
    default:
      break
    }

    client?.urlProtocolDidFinishLoading(self)
  }
}

/// Contains static functions to create successful and error responses.
extension FakeURLProtocol {
  enum MockError: Error {
    case none
  }

  /// Create a failed response.
  static func responseWithFailure() {
    FakeURLProtocol.responseType = FakeURLProtocol.ResponseType.error(MockError.none)
  }

  /// Create a successful response with the given inputs.
  ///
  /// - Parameters:
  ///   - code: The HTTP code to use in the response.
  ///   - asciiString: ASCII encoded text to serve as the response's text.
  static func responseWithStatusCode(code: Int, asciiString: String) {
    let url = URL(string: "http://any.com")!
    let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    FakeURLProtocol.responseType = FakeURLProtocol.ResponseType.success(response, asciiString)
  }
}
