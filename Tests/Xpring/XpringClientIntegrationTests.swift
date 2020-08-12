import XCTest
import XpringKit

public class XpringClientIntegrationTest: XCTestCase {
  /// The network to conduct tests on.
  private let network = XRPLNetwork.test

  func testSendXRPAsync() throws {
    // GIVEN a Pay ID that will resolve and a wallet with a balance on TestNet and a XpringClient.
    let payID = "alice$dev.payid.xpring.money"
    let wallet = try! Wallet.randomWalletFromFaucet()
    let payIDClient = XRPPayIDClient(xrplNetwork: network)
    let xrpClient = XRPClient(grpcURL: "test.xrp.xpring.io:50051", network: .test)
    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the Pay ID asynchronously THEN a transaction hash is returned.
    let transactionSentExpectation = XCTestExpectation(description: "Transaction hash received.")
    xpringClient.send(10, to: payID, from: wallet) { result in
      switch result {
      case .success(let transactionHash):
        XCTAssertNotNil(transactionHash)
        transactionSentExpectation.fulfill()
      case .failure:
        XCTFail("Error making transaction")
      }
    }

    self.wait(for: [transactionSentExpectation], timeout: 10)
  }

  func testSendXRPSync() throws {
    // GIVEN a Pay ID that will resolve and a wallet with a balance on TestNet and a XpringClient.
    let payID = "alice$dev.payid.xpring.money"
    let wallet = try! Wallet.randomWalletFromFaucet()
    let payIDClient = XRPPayIDClient(xrplNetwork: network)
    let xrpClient = XRPClient(grpcURL: "test.xrp.xpring.io:50051", network: .test)
    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the Pay ID synchronously
    let result = xpringClient.send(10, to: payID, from: wallet)

    // THEN a transaction hash is returned.
    switch result {
    case .success(let transactionHash):
      XCTAssertNotNil(transactionHash)
    case .failure:
      XCTFail("Error making transaction")
    }
  }
}
