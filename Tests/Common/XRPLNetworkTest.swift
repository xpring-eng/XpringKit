import XCTest
import XpringKit

final class XRPLNetworkTest: XCTestCase {

  func testXRPLNetworkIsTestTestnet() {
    // GIVEN an XRPLNetwork instance that represents XRPL Testnet.
    let xrplNetwork = XRPLNetwork.test

    // WHEN isTest is called THEN the result is true.
    XCTAssertTrue(xrplNetwork.isTest)
  }

  func testXRPLNetworkIsTestDevnet() {
    // GIVEN an XRPLNetwork instance that represents XRPL Devnet.
    let xrplNetwork = XRPLNetwork.dev

    // WHEN isTest is called THEN the result is true.
    XCTAssertTrue(xrplNetwork.isTest)
  }

  func testXRPLNetworkIsTestMainnet() {
    // GIVEN an XRPLNetwork instance that represents XRPL Mainnet.
    let xrplNetwork = XRPLNetwork.main

    // WHEN isTest is called THEN the result is false.
    XCTAssertFalse(xrplNetwork.isTest)
  }
}
