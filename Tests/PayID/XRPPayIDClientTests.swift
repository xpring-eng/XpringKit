import Alamofire
import XCTest
@testable import XpringKit

final class XRPPayIDClientTest: XCTestCase {
  static let manager: SessionManager = {
    let configuration: URLSessionConfiguration = {
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [FakeURLProtocol.self]
      return configuration
    }()

    return SessionManager(configuration: configuration)
  }()

  let payIDClient = {
    XRPPayIDClient(xrplNetwork: .test, sessionManager: manager)
  }()

  let paymentNetwork = "xrpl-testnet"
  let jsonEncoder = JSONEncoder()

  func testXrpAddressWithXAddress() throws {
    // GIVEN An XRPPayIDClient with faked networking to return a successful response as an X-Address.
    let paymentNetwork = "xrpl-testnet"
    let address = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
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
    self.mockNetworking(toReturn: paymentInformation)

    // WHEN the associated address is retrieved.
    let result = payIDClient.xrpAddress(for: "georgewashington$xpring.money")

    // THEN the X-Address is returned unchanged.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertEqual(resolvedAddress, address)
    case .failure(let error):
      XCTFail("Failed to resolve PayID with Error error: \(error)")
    }
  }

  func testXrpAddressWithClassicAddressAndNoTag() throws {
    // GIVEN An XRPPayIDClient with faked networking to return a successful response as a classic address.
    let paymentNetwork = "xrpl-testnet"
    let address = "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY"
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
    self.mockNetworking(toReturn: paymentInformation)

    // WHEN the associated address is retrieved.
    let result = payIDClient.xrpAddress(for: "georgewashington$xpring.money")

    // THEN the resolved address is an encoded X-Address.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertEqual(resolvedAddress, Utils.encode(classicAddress: address, isTest: true))
    case .failure(let error):
      XCTFail("Failed to resolve PayID with Error error: \(error)")
    }
  }

  func testXrpAddressWithClassicAddressAndTag() throws {
    // GIVEN An XRPPayIDClient with faked networking to return a successful response as a classic address and tag
    let paymentNetwork = "xrpl-testnet"
    let address = "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY"
    let tag: UInt32 = 12345
    let paymentInformation = PaymentInformation(
      addresses: [
        PayIDAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: address,
            tag: "\(tag)"
          )
        )
      ]
    )
    self.mockNetworking(toReturn: paymentInformation)

    // WHEN the associated address is retrieved.
    let result = payIDClient.xrpAddress(for: "georgewashington$xpring.money")

    // THEN the resolved address is an encoded X-Address.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertEqual(resolvedAddress, Utils.encode(classicAddress: address, tag: tag, isTest: true))
    case .failure(let error):
      XCTFail("Failed to resolve PayID with Error error: \(error)")
    }
  }

  func testXrpAddressWithMultipleClassicAddressesReturned() throws {
    // GIVEN An XRPPayIDClient with faked networking to return a successful response with multiple classic addresses.
    let paymentNetwork = "xrpl-testnet"
    let address = "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY"
    let tag: UInt32 = 12345
    let paymentInformation = PaymentInformation(
      addresses: [
        PayIDAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: address,
            tag: "\(tag)"
          )
        ),
        PayIDAddress(
          paymentNetwork: paymentNetwork,
          addressDetailsType: "CryptoAddressDetails",
          addressDetails: CryptoAddressDetails(
            address: address
          )
        )
      ]
    )
    self.mockNetworking(toReturn: paymentInformation)

    // WHEN the associated address is retrieved.
    let result = payIDClient.xrpAddress(for: "georgewashington$xpring.money")

    // THEN the an unexpected response error is returned.
    switch result {
    case .success:
      XCTFail("Should not resolve an X-Address")
    case .failure(let error):
      XCTAssertEqual(error, PayIDError.unexpectedResponse)
    }
  }

  /// Mock networking to return the given `PaymentInformation` when a PayID request is made.
  private func mockNetworking(toReturn paymentInformation: PaymentInformation) {
    let response = try! jsonEncoder.encode(paymentInformation)
    FakeURLProtocol.responseWithStatusCode(code: 200, asciiString: String(data: response, encoding: .utf8)!)
  }
}
