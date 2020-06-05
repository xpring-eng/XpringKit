import Foundation

final class FakeURLProtocol: URLProtocol {

  enum ResponseType {
    case error(Error)
    case success(HTTPURLResponse, String)
  }
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
extension FakeURLProtocol: URLSessionDataDelegate {

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
  }

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

extension FakeURLProtocol {

  enum MockError: Error {
    case none
  }

  static func responseWithFailure() {
    FakeURLProtocol.responseType = FakeURLProtocol.ResponseType.error(MockError.none)
  }

  static func responseWithStatusCode(code: Int, asciiString: String) {
    let url = URL(string: "http://any.com")!
    let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    return FakeURLProtocol.responseType = FakeURLProtocol.ResponseType.success(response, asciiString)
  }
}
