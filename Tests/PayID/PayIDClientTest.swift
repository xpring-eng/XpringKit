import Alamofire
import Foundation
import XCTest
import XpringKit

final class PayIDClientTest: XCTestCase {
  static let manager: SessionManager = {
    let configuration: URLSessionConfiguration = {
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [FakeURLProtocol.self]
      return configuration
    }()

    return SessionManager(configuration: configuration)
  }()

  let payIDClient = {
    PayIDClient(sessionManager: manager)
  }()

  let paymentNetwork = "xrpl-testnet"
  let jsonEncoder = JSONEncoder()

  func testAddressWithInvalidPayID() {
    // GIVEN an invalid PayID.
    let invalidPayID = "xpring.money/georgewashington" // Does not contain '$'

    // WHEN an address is requested for an invalid PayID.
    let result = payIDClient.cryptoAddress(for: invalidPayID, on: paymentNetwork)

    // THEN the response is an invalid PayID error.
    switch result {
    case .success:
      XCTFail("Should not resolve an address for an invalid PayID.")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.invalidPayID(payID: invalidPayID))
    }
  }

  func testAddressWithSuccessResponseMatchFound() {
    // GIVEN A PayIDClient with faked networking to return a successful response.
    let address = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
    let paymentNetwork = "xrpl-testnet"
    let paymentInformation = PaymentInformation(
      addresses: [
        PayIDAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: address
          )
        )
      ]
    )

    let response = try! jsonEncoder.encode(paymentInformation)

    FakeURLProtocol.responseWithStatusCode(code: 200, asciiString: String(data: response, encoding: .utf8)!)

    // WHEN the associated address is retrieved.
    let result = payIDClient.cryptoAddress(for: "georgewashington$xpring.money", on: paymentNetwork)

    // THEN the response contains the expected address.
    switch result {
    case .success(let addressDetails):
      XCTAssertEqual(addressDetails.address, address)
    case .failure(let error):
      XCTFail("Failed to resolve PayID with Error error: \(error)")
    }
  }

  func testAddressWithMatchNotFound() {
    // GIVEN mocked networking to return a 404 for a request to resolve a PayID.
    let payID = "georgewashington$xpring.money"
    FakeURLProtocol.responseWithStatusCode(code: 404, asciiString: "not found")

    // WHEN an address is resolved.
    let result = payIDClient.cryptoAddress(for: payID, on: paymentNetwork)

    // THEN the result is a not found error.
    switch result {
    case .success:
      XCTFail("Should not resolve an address")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.mappingNotFound(payID: payID, network: paymentNetwork))
    }
  }

  func testAddressWithUnknownMIMEType() {
    // GIVEN mocked networking to return a 415 for a request to resolve a PayID.
    let payID = "georgewashington$xpring.money"
    FakeURLProtocol.responseWithStatusCode(code: 415, asciiString: "Unknown MIME type requested.")

    // WHEN an address is resolved.
    let result = payIDClient.cryptoAddress(for: payID, on: paymentNetwork)

    // THEN the result is an unexpected response.
    switch result {
    case .success:
      XCTFail("Should not resolve an address")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.unexpectedResponse)
    }
  }
  
  func testAddressWithGenericServerError() {
    // GIVEN mocked networking to return a 415 for a request to resolve a PayID.
    let payID = "georgewashington$xpring.money"
    FakeURLProtocol.responseWithStatusCode(
      code: 503,
      asciiString: "Something went wrong and it isn't your fault."
    )

    // WHEN an address is resolved.
    let result = payIDClient.cryptoAddress(for: payID, on: paymentNetwork)

    // THEN the result is an unexpected response.
    switch result {
    case .success:
      XCTFail("Should not resolve an address")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.unexpectedResponse)
    }
  }

  func testAddressWithSuccessResponseUnexpectedResponseFormat() {
    // GIVEN mocked networking to return a 200 with an unexpected format..
    let payID = "georgewashington$xpring.money"
    let malformedResponse = [
      "address": "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"

    ] // Not wrapped in a PaymentInformation object.
    let malformedResponseBytes = try! jsonEncoder.encode(malformedResponse)
    FakeURLProtocol.responseWithStatusCode(
      code: 200,
      asciiString: String(data: malformedResponseBytes, encoding: .utf8)!
    )

    // WHEN an address is resolved.
    let result = payIDClient.cryptoAddress(for: payID, on: paymentNetwork)

    // THEN the result is an unexpected response.
    switch result {
    case .success:
      XCTFail("Should not resolve an address")
    case .failure(let error):
//      XCTAssertEqual(error, PayIDError.unknown(error: ))
    }
  }

}
