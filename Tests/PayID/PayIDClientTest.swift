import Alamofire
import Foundation
import XCTest
import XpringKit

final class MockURLProtocol: URLProtocol {

    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
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

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
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
extension MockURLProtocol: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        default:
            break
        }

        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockURLProtocol {

    enum MockError: Error {
        case none
    }

    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }

    static func responseWithStatusCode(code: Int) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(HTTPURLResponse(url: URL(string: "http://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
}

class PayIDClientTest: XCTestCase {
//  override func setUp() {
//      super.setUp()
//
//      let manager: SessionManager = {
//          let configuration: URLSessionConfiguration = {
//              let configuration = URLSessionConfiguration.default
//              configuration.protocolClasses = [MockURLProtocol.self]
//              return configuration
//          }()
//
//          return SessionManager(configuration: configuration)
//      }()
//
//    Alamofire.SessionManager
//  }

  func testXRPAddressForInvalidPayID() {
    // GIVEN a PayIDClient and an invalid PayID.
    let invalidPayID = "xpring.money/georgewashington" // Does not start with '$'
    let payIDClient = PayIDClient(network: .test)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for an invalid pay ID
    payIDClient.xrpAddress(for: invalidPayID) { result in
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
    let address = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
    let urlResponse = HTTPURLResponse(
      url: URL(string: "https://xpring.money/georgewashington")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    let fakeResponse = "{ addressDetailsType: 'CryptoAddressDetails', addressDetails: { address: '\(address)' }}"
    let fakeURLSession = FakeURLSession(string: fakeResponse, urlResponse: urlResponse, error: nil)
    let payIDClient = PayIDClient(network: .test)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for the Pay ID
    payIDClient.xrpAddress(for: payID) { result in
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
    let payIDClient = PayIDClient(network: .test)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for an invalid pay ID
    payIDClient.xrpAddress(for: payID) { result in
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
    let payIDClient = PayIDClient(network: .test)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for an invalid pay ID
    payIDClient.xrpAddress(for: payID) { result in
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
    let payIDClient = PayIDClient(network: .test)
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // WHEN an XRPAddress is requested for the Pay ID
    payIDClient.xrpAddress(for: payID) { result in
      // THEN the result resolves to an malformed response error.
      switch result {
      case .success:
        XCTFail("Should not have been able to resolve Pay ID")
      case .failure(let payIDError):
        guard case PayIDError.unexpectedResponse = payIDError else {
          XCTFail("Incorrect error type")
          return
        }
      }
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }
}
