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
  func testResolvePaymentPointerKnownPointerMainnetSync() {
    // GIVEN a Pay ID that will resolve on Mainnet and a PayID client.
    let payIDClient = XRPPayIDClient(xrplNetwork: .main)

    // WHEN it is resolved to an XRP address synchronously.
    let result = payIDClient.xrpAddress(for: .testPointer)

    // THEN the address is the expected value.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertEqual(resolvedAddress, "X7zmKiqEhMznSXgj9cirEnD5sWo3iZSbeFRexSFN1xZ8Ktn")
    case .failure(let error):
      XCTFail("Failed to resolve address: \(error)")
    }
  }

  func testResolvePaymentPointerKnownPointerMainnetAsync() {
    // GIVEN a Pay ID that will resolve on Mainnet and a PayID client.
    let payIDClient = XRPPayIDClient(xrplNetwork: .main)

    // WHEN it is resolved to an XRP address asynchronously.
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")
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
  func testResolveXRPAddressKnownPayIDMainnetOnCustomThread() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a PayID that will resolve on Mainnet, an XRPPayIDClient and a custom callback queue.
    let queueLabel = "io.xpring.XpringKit.test"
    let customCallbackQueue = DispatchQueue(label: queueLabel)
    DispatchQueue.registerDetection(of: customCallbackQueue)
    let payIDClient = XRPPayIDClient(xrplNetwork: .main)

    // WHEN it is resolved to an address and provided a custom queue
    // THEN the callback is performed on the custom queue.
    payIDClient.xrpAddress(for: .testPointer, callbackQueue: customCallbackQueue) { _ in
      XCTAssertEqual(DispatchQueue.currentQueueLabel, queueLabel)
      expectation.fulfill()
    }

    self.wait(for: [ expectation ], timeout: 10)
  }

  // TODO(keefertaylor): This should  be a unit test. Migrate when
  // https://github.com/xpring-eng/XpringKit/pull/238 is landed.
  func testResolveAddressKnownPayIDMainnetOnCustomThread() {
    let expectation = XCTestExpectation(description: "resolveToXRP completion called.")

    // GIVEN a PayID that will resolve on Mainnet, a PayIDClient and a custom callback queue.
    let queueLabel = "io.xpring.XpringKit.test"
    let customCallbackQueue = DispatchQueue(label: queueLabel)
    DispatchQueue.registerDetection(of: customCallbackQueue)
    let payIDClient = PayIDClient(network: "xrpl-main")

    // WHEN it is resolved to an XRP address and provided a custom queue
    // THEN the callback is performed on the custom queue.
    payIDClient.address(for: .testPointer, callbackQueue: customCallbackQueue) { _ in
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
    let payIDClient = PayIDClient(network: "btc-testnet")
    let result = payIDClient.address(for: .testPointer)

    // THEN the address is the expected value.
    switch result {
    case .success(let resolvedAddress):
      XCTAssertEqual(resolvedAddress.address, "2NF9H32iwQcVcoAiiBmAtjpGmQfsmU5L6SR")
    case .failure(let error):
      XCTFail("Failed to resolve address: \(error)")
    }
  }
}
