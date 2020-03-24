import Foundation

/// A fake URLSession that will return data tasks which will call completion handlers with the given parameters.
public class FakeURLSession: URLSession {
  /// Fields that will be returned in the next URLSessionDataTask.
  public var urlResponse: URLResponse?
  public var data: Data?
  public var error: Error?

  /// Initialize a new FakeURLSession.
  ///
  /// - Parameters:
  ///   - string: A utf-8 encoded string that will be encoded as data in the next request.
  ///   - urlResponse: The url response to serve in the next request.
  ///   - error: The error to serve in the next request.
  public convenience init(string: String, urlResponse: HTTPURLResponse?, error: Error?) {
    let data = string.data(using: .utf8)
    self.init(data: data, urlResponse: urlResponse, error: error)
  }

  /// Initialize a new FakeURLSession.
  ///
  /// - Parameters:
  ///   - data: The data to serve in the next request.
  ///   - urlResponse: The url response to serve in the next request.
  ///   - error: The error to serve in the next request.
  public init(data: Data?, urlResponse: HTTPURLResponse?, error: Error?) {
    self.data = data
    self.urlResponse = urlResponse
    self.error = error
  }

  public override func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    return FakeURLSessionDataTask(
      urlResponse: urlResponse,
      data: data,
      error: error,
      completionHandler: completionHandler
    )
  }
}
