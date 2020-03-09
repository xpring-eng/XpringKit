//import Foundation
//
///// Fakes a URLSession for testing.
//class FakeURLSession: URLSession {
//  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
//
//  // Data returned by the next request
//  var data: Data?
//
//  // The HTTPURLResponse returned by the next request
//  var urlResponse: HTTPURLResponse?
//
//  // Error returned by the next request.
//  var error: Error?
//
//  public init(string: String?, urlResponse: HTTPURLResponse?, error: Error?) {
//    self.data = string?.data(using: .utf8)
//    self.urlResponse = urlResponse
//    self.error = error
//
//    super.init()
//  }
//
//  override func dataTask(
//    with url: URL,
//    completionHandler: @escaping CompletionHandler
//  ) -> URLSessionDataTask {
//    return FakeURLSessionDataTask {
//      completionHandler(self.data, self.urlResponse, self.error)
//    }
//  }
//}
