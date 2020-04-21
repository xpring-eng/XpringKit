import XCTest
import XpringKit

extension PaymentPointer {
  /// The PayID to resolve.
  public static let testPointer = "$dev.payid.xpring.money/alice"
}

/// Integration tests run against a live PayID service.
final class PayIDIntegrationTests: XCTestCase {
  func testResolvePaymentPointerKnownPointerMainnet() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will resolve on mainnet and a PayID client.
    let payIDClient = PayIDClient(network: .main)

    // WHEN it is resolved to an XRP address.
    payIDClient.xrpAddress(for: .testPointer) { result in
      // THEN the address is the expected value.
      switch result {
      case .success(let resolvedAddress):
        XCTAssertEqual(resolvedAddress, "X7zmKiqEhMznSXgj9cirEnD5sWo3iZSbeFRexSFN1xZ8Ktn")
      case .failure(let error):
        XCTFail("Failed to resolve address: \(error)")
      }

      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  func testResolvePaymentPointerKnownPointerTestnet() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will resolve on testnet and a PayID client.
    let payIDClient = PayIDClient(network: .test)

    // WHEN it is resolved to an XRP address.
    payIDClient.xrpAddress(for: .testPointer) { result in
      // THEN the address is the expected value.
      switch result {
      case .success(let resolvedAddress):
        XCTAssertEqual(resolvedAddress, "TVacixsWrqyWCr98eTYP7FSzE9NwupESR4TrnijN7fccNiS")
      case .failure(let error):
        XCTFail("Failed to resolve address: \(error)")
      }

      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  func testResolvePaymentPointerKnownPointerDevnet() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will not resolve on Devnet and a PayID client.
    let payIDClient = PayIDClient(network: .dev)

    // WHEN it is resolved to an XRP address.
    payIDClient.xrpAddress(for: .testPointer) { result in
      // THEN the result contains an `mappingNotFound` error.
      switch result {
      case .success:
        XCTFail("Should not resolve an address")
      case .failure(let error):
        switch error {
        case .mappingNotFound:
          expectation.fulfill()
        default:
          XCTFail("Wrong error type thrown")
        }
      }
    }

    self.wait(for: [ expectation ], timeout: 10)
  }
}
