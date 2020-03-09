import Foundation

/// Fakes a URLSession for testing.
class FakeURLSession: URLSession {
  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

  // The data task that will be returned.
  var fakeDataTask: FakeURLSessionDataTask

  public init(fakeDataTask: FakeURLSessionDataTask) {
    self.fakeDataTask = fakeDataTask
  }

  override func dataTask(
    with url: URL,
    completionHandler: @escaping CompletionHandler
  ) -> URLSessionDataTask {
    return fakeDataTask
  }
}
