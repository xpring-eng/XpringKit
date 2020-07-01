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

  func testAddressWithSuccessResponseUnknownResponseFormat() {
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
      guard case .unknown = error else {
        XCTFail("Should return unknown error type")
        return
      }
    }
  }

  func testAllAddressesWithInvalidPayID() {
    // GIVEN an invalid PayID.
    let invalidPayID = "xpring.money/georgewashington" // Does not contain '$'

    // WHEN all addresses are requested.
    let result = payIDClient.allAddresses(for: invalidPayID)

    // THEN the response is an invalid PayID error.
    switch result {
    case .success:
      XCTFail("Should not resolve an address for an invalid PayID.")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.invalidPayID(payID: invalidPayID))
    }
  }

  func testAllAddressesForPayIDMatchFound() {
    // GIVEN a valid PayID and mocked networking to return a set of matches for the PayID.
    let payID = "georgewashington$xpring.money"
    let matches = PaymentInformation(
      addresses: [
        PayIDAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
          )
        ),
        PayIDAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: "XV5sbjUmgPpvXv4ixFWZ5ptAYZ6PD28Sq49uo34VyjnmK5H"
          )
        )
      ]
    )
    let matchesBytes = try! jsonEncoder.encode(matches)
    FakeURLProtocol.responseWithStatusCode(
      code: 200,
      asciiString: String(data: matchesBytes, encoding: .utf8)!
    )

    // WHEN all addresses are resolved.
    let result = payIDClient.allAddresses(for: payID)

    // THEN the returned data is as expected.
    switch result {
    case .success(let results):
      XCTAssertEqual(results.count, 2)
    case .failure:
      XCTFail("Should have resolved a set of addresses")
    }
  }

  func testAllAddressesWithMatchNotFound() {
    // GIVEN mocked networking to return a 404 for a request to resolve a PayID.
    let payID = "georgewashington$xpring.money"
    FakeURLProtocol.responseWithStatusCode(code: 404, asciiString: "not found")

    // WHEN an address is resolved.
    let result = payIDClient.allAddresses(for: payID)

    // THEN the result is a not found error.
    switch result {
    case .success:
      XCTFail("Should not resolve an address")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.mappingNotFound(payID: payID, network: "payid"))
    }
  }
}
