import XCTest
import XpringKit

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
