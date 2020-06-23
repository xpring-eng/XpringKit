import Alamofire
import Foundation
import XCTest
import XpringKit

final class PayIDClientTest: XCTestCase {
  func testAddressWithSuccessResponse() {
    // GIVEN A PayIDClient with faked networking to return a successful response.
    let address = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
    let paymentNetwork = "xrpl-testnet"
    let paymentInformation = PaymentInformation(
      addresses: [
        PayIdAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: address
          )
        )
      ]
    )

    let jsonEncoder = JSONEncoder()
    let response = try! jsonEncoder.encode(paymentInformation)

    let manager: SessionManager = {
      let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [FakeURLProtocol.self]
        return configuration
      }()

      return SessionManager(configuration: configuration)
    }()

    FakeURLProtocol.responseWithStatusCode(code: 200, asciiString: String(data: response, encoding: .utf8)!)

    let payIDClient = PayIDClient(network: paymentNetwork, sessionManager: manager)

    // WHEN the associated address is retrieved.
    let expectation = XCTestExpectation(description: "Retrieved a PayID")
    payIDClient.address(for: "georgewashington$xpring.money") { result in
      // THEN the response contains the expected address.
      switch result {
      case .success(let addressDetails):
        XCTAssertEqual(addressDetails.address, address)
      case .failure(let error):
        XCTFail("flagrant error: \(error)")
      }

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 10)
  }

  // TODO(keefertaylor): Write additional PayID tests here in a follow up PR.
}
