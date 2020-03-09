import XCTest
import XpringKit

extension PaymentPointer {
  /// The PayID to resolve.
  public static let testPointer = "$doug.purdy.im"
}

/// Integration tests run against a live PayID service.
final class PayIDIntegrationTests: XCTestCase {
  private let payIDClient = PayIDClient()

  func testResolvePaymentPointer() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will resolve WHEN it is resolved to an XRP address
    payIDClient.resolveToXRP(.testPointer) { result in
      // THEN the address is the expected value.
      switch result {
      case .success(let resolvedAddress):
        XCTAssertEqual(resolvedAddress, "r9wmZ8Ctfdcr9gctT7LresUve7vs14ADcz")
      case .failure(let error):
        XCTFail("Failed to resolve address: \(error)")
      }

      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 60)
  }

  // TODO(keefertaylor): Add a test for a PayID mapping which doesn't exist. https://doug.purdy.im returns 403 errors
  // for paths which do not exist, rather than 404s.
}
