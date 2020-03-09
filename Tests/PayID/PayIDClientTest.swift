import XCTest
import XpringKit

/// A fake URLSession that will return data tasks which will call completion handlers with the given parameters.
public class FakeURLSession: URLSession {
  public var urlResponse: URLResponse?
  public var data: Data?
  public var error: Error?

  public convenience init(string: String, urlResponse: HTTPURLResponse?, error: Error?) {
    let data = string.data(using: .utf8)
    self.init(data: data, urlResponse: urlResponse, error: error)
  }

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

/// A fake data task that will immediately call completion.
public class FakeURLSessionDataTask: URLSessionDataTask {
  private let urlResponse: URLResponse?
  private let data: Data?
  private let fakedError: Error?
  private let completionHandler: (Data?, URLResponse?, Error?) -> Void

  public init(
    urlResponse: URLResponse?,
    data: Data?,
    error: Error?,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
    self.urlResponse = urlResponse
    self.data = data
    self.fakedError = error
    self.completionHandler = completionHandler
  }

  public override func resume() {
    completionHandler(data, urlResponse, fakedError)
  }
}

class PayIDClientTest: XCTestCase {

  func testXRPAddressForInvalidPayID() {
    // GIVEN a PayIDClient and an invalid PayID.
    let invalidPayID = "xpring.money/georgewashington" // Does not start with '$'
    let payIDClient = PayIDClient()
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for an invalid pay ID
    payIDClient.resolveToXRP(invalidPayID) { result in
      // THEN the result resolves to an invalid payment pointer error.
      switch result {
      case .success:
        XCTFail("Should not resolve to an address")
      case .failure(let payIDError):
        guard case PayIDError.invalidPaymentPointer(_) = payIDError else {
          XCTFail("Incorrect error type")
          return
        }
      }
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  func testXRPAddressForResolvablePayID() {
    // GIVEN a PayIDClient that has faked networking to return an XRP address
    let payID = "$xpring.money/georgewashington"
    let address = "r9wmZ8Ctfdcr9gctT7LresUve7vs14ADcz"
    let urlResponse = HTTPURLResponse(
      url: URL(string: "https://xpring.money/georgewashington")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    let fakeResponse = "{\"address\": \"\(address)\"}"
    let fakeURLSession = FakeURLSession(string: fakeResponse, urlResponse: urlResponse, error: nil)
    let payIDClient = PayIDClient(urlSession: fakeURLSession)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for the Pay ID
    payIDClient.resolveToXRP(payID) { result in
      // THEN the result resolves to the address.
      switch result {
      case .success(let resolvedAddress):
        XCTAssertEqual(resolvedAddress, address)
      case .failure:
        XCTFail("Should not encounter error resolving PayID")
      }
      expectation.fulfill()
    }
    self.wait(for: [ expectation ], timeout: 10)
  }

  func testXRPAddressForUnresolvablePayID() {
    // GIVEN a PayIDClient that has faked networking to return an unmapped Pay ID response
    let payID = "$xpring.money/georgewashington"
    let urlResponse = HTTPURLResponse(
      url: URL(string: "https://xpring.money/georgewashington")!,
      statusCode: 404,
      httpVersion: nil,
      headerFields: nil
    )
    let fakeURLSession = FakeURLSession(data: nil, urlResponse: urlResponse, error: nil)
    let payIDClient = PayIDClient(urlSession: fakeURLSession)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for an invalid pay ID
    payIDClient.resolveToXRP(payID) { result in
      // THEN the result resolves to success with no address found.
      switch result {
      case .success(let resolvedAddress):
        XCTAssertNil(resolvedAddress)
      case .failure:
        XCTFail("Should not encounter error resolving PayID")
      }
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  func testXRPAddressForServerError() {
    // GIVEN a PayIDClient that has faked networking to return a server error
    let payID = "$xpring.money/georgewashington"
    let urlResponse = HTTPURLResponse(
      url: URL(string: "https://xpring.money/georgewashington")!,
      statusCode: 500,
      httpVersion: nil,
      headerFields: nil
    )
    let fakeURLSession = FakeURLSession(data: nil, urlResponse: urlResponse, error: nil)
    let payIDClient = PayIDClient(urlSession: fakeURLSession)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for an invalid pay ID
    payIDClient.resolveToXRP(payID) { result in
      // THEN the result resolves to an unknown error.
      switch result {
      case .success:
        XCTFail("Should not have been able to resolve Pay ID")
      case .failure(let payIDError):
        guard case PayIDError.unknown(_) = payIDError else {
          XCTFail("Incorrect error type")
          return
        }

      }
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  func testXRPAddressForMalformedResponse() {
    // GIVEN a PayIDClient that has faked networking to return a malformed response
    let payID = "$xpring.money/georgewashington"
    let address = "r9wmZ8Ctfdcr9gctT7LresUve7vs14ADcz"
    let fakeResponse = "{ \"xrp\": \"\(address)\"}" // wrong field name
    let urlResponse = HTTPURLResponse(
      url: URL(string: "https://xpring.money/georgewashington")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    let fakeURLSession = FakeURLSession(string: fakeResponse, urlResponse: urlResponse, error: nil)
    let payIDClient = PayIDClient(urlSession: fakeURLSession)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for the Pay ID
    payIDClient.resolveToXRP(payID) { result in
      // THEN the result resolves to an malformed response error.
      switch result {
      case .success:
        XCTFail("Should not have been able to resolve Pay ID")
      case .failure(let payIDError):
        guard case PayIDError.malformedResponse = payIDError else {
          XCTFail("Incorrect error type")
          return
        }
      }
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }
}
