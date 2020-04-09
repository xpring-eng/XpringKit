import XCTest
import XpringKit

extension String {
  /// The URL of a remote rippled node with gRPC enabled.
  public static let remoteURL = "test.xrp.xpring.io:50051"

  /// An address on the chain to receive funds.
  public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

/// Integration tests run against a live remote client.
final class XRPClientIntegrationTests: XCTestCase {
  private let client = XRPClient(grpcURL: .remoteURL, network: .test)

  // MARK: - rippled Protocol Buffers

  func testGetBalance() {
    do {
      _ = try client.getBalance(for: Wallet.testWallet.address)
    } catch {
      XCTFail("Failed retrieving balance with error: \(error)")
    }
  }

  func testSendXRP() {
    do {
      _ = try client.send(.testSendAmount, to: .recipientAddress, from: .testWallet)
    } catch {
      XCTFail("Failed sending XRP with error: \(error)")
    }
  }

  func testPaymentStatus() {
    do {
      let transactionHash = try client.send(.testSendAmount, to: .recipientAddress, from: .testWallet)
      let transactionStatus = try client.paymentStatus(for: transactionHash)
      XCTAssertEqual(transactionStatus, .succeeded)
    } catch {
      XCTFail("Failed retrieving transaction hash with error: \(error)")
    }
  }

  func testAccountExists() {
      do {
        _ = try client.accountExists(for: Wallet.testWallet.address)
      } catch {
        XCTFail("Failed checking account existence with error: \(error)")
      }
  }

  func testPaymentHistory() {
    do {
      let payments = try client.paymentHistory(for: Wallet.testWallet.address)
      XCTAssert(payments.count > 0)
    } catch {
      XCTFail("Failed checking account existence with error: \(error)")
    }
  }
}
