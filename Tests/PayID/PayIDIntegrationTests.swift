import Foundation
import XCTest
import XpringKit

extension PaymentPointer {
  public static let testPointer = "alice$dev.payid.xpring.money"

  /// A pay ID that does not exist.
  public static let nonExistentPointer = "doesNotExist$dev.payid.xpring.money"
}

/// Integration tests run against a live PayID service.
final class PayIDIntegrationTests: XCTestCase {
  func testResolvePaymentPointerKnownPointerMainnet() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will resolve on Mainnet and a PayID client.
    let payIDClient = XRPPayIDClient(xrplNetwork: .main)

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

  // TODO(keefertaylor): This should  be a unit test. Migrate when
  // https://github.com/xpring-eng/XpringKit/pull/238 is landed.
  func testResolvePaymentPointerKnownPointerMainnetOnCustomThread() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will resolve on Mainnet and a PayID client and a custom callback queue.
    let queueLabel = "io.xpring.XpringKit.test"
    let customCallbackQueue = DispatchQueue(label: queueLabel)
    DispatchQueue.registerDetection(of: customCallbackQueue)
    let payIDClient = PayIDClient()

    // WHEN it is resolved to an XRP address and provided a custom queue and not on the main thread.
    payIDClient.cryptoAddress(for: .testPointer, on: "xrpl-main", callbackQueue: customCallbackQueue) { _ in
      XCTAssertEqual(DispatchQueue.currentQueueLabel, queueLabel)
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  func testResolvePaymentPointerKnownPointerTestnet() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a Pay ID that will resolve on testnet and a PayID client.
    let payIDClient = XRPPayIDClient(xrplNetwork: .test)

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
    let payIDClient = XRPPayIDClient(xrplNetwork: .dev)

    // WHEN it is resolved to an XRP address.
    payIDClient.xrpAddress(for: .nonExistentPointer) { result in
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

  func testResolveKnownPayIDToBTCTestNet() {
    // GIVEN a Pay ID that will resolve on Mainnet.
    // WHEN it is resolved to an XRP address
    let payIDClient = PayIDClient()
    let result = payIDClient.cryptoAddress(for: .testPointer, on: "btc-testnet")

    // THEN the address is the expected value.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertEqual(resolvedAddress.address, "2NF9H32iwQcVcoAiiBmAtjpGmQfsmU5L6SR")
    case .failure(let error):
      XCTFail("Failed to resolve address: \(error)")
    }
  }

  func testAllAddressesSync() {
    // GIVEN a PayID with multiple addresses.
    // WHEN all addresses are synchronously resolved.
    let payIDClient = PayIDClient()
    let result = payIDClient.allAddresses(for: .testPointer)

    // THEN multiple results are returned.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertTrue(resolvedAddress.count > 1)
    case .failure(let error):
      XCTFail("Failed to resolve address: \(error)")
    }
  }

  func testAllAddressesASync() {
    let expectation = XCTestExpectation(description: "completion called.")

    // GIVEN a PayID with multiple addresses.
    // WHEN all addresses are synchronously resolved.
    let payIDClient = PayIDClient()
    payIDClient.allAddresses(for: .testPointer) { result in
      // THEN multiple results are returned.
      switch result {
      case .success(let resolvedAddress):
        XCTAssertTrue(resolvedAddress.count > 1)
      case .failure(let error):
        XCTFail("Failed to resolve address: \(error)")
      }
      expectation.fulfill()
    }
    self.wait(for: [ expectation ], timeout: 10)
  }
}
