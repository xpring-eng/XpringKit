import Alamofire
import Foundation
import XCTest
import XpringKit

final class PayIDClientTest: XCTestCase {
  // TODO(keefertaylor): Better naming.
  func testGet() {
    let manager: SessionManager = {
      let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [FakeURLProtocol.self]
        return configuration
      }()

      return SessionManager(configuration: configuration)
    }()

    // TODO(keefertaylor): We can probably encode a native dictionary rather than inlining JSON.
    let response = """
    {
      "addresses": [{
        "addressDetailsType": "CryptoAddressDetails",
        "addressDetails": {
          "address": "my-address-here"
        },
        "paymentNetwork": "xrpl"
      }]
    }
    """

    FakeURLProtocol.responseWithStatusCode(code: 200, asciiString: response)
    let expectation = XCTestExpectation(description: "Got a response")

    let payIDClient = PayIDClient(network: "xrpl-testnet", sessionManager: manager)
    payIDClient.address(for: "keefer$keefertaylor.com") { result in
      switch result {
      case .success(let addressDetails):
        XCTAssertEqual(addressDetails.address, "my-address-here")
      case .failure(let error):
        XCTFail("flagrant error: \(error)")
      }

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 10)

    XCTAssertEqual(1 + 1, 2)
  }
}
