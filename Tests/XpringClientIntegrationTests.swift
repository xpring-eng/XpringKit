import XCTest
import XpringKit

/// Integration tests run against a live remote client.
final class XpringClientIntegrationTests: XCTestCase {
  private let legacyClient = XpringClient(grpcURL: .legacyRemoteURL, useNewProtocolBuffers: false)
  private let client = XpringClient(grpcURL: .remoteURL, useNewProtocolBuffers: true)

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

  func testGetTransactionStatus() {
    do {
      let transactionStatus = try client.getTransactionStatus(for: .successfulTransactionHash)
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

  // MARK: - Legacy Protocol Buffers

  func testGetBalance_legacy() {
    do {
      _ = try legacyClient.getBalance(for: Wallet.testWallet.address)
    } catch {
      XCTFail("Failed retrieving balance with error: \(error)")
    }
  }

  func testSendXRP_legacy() {
    do {
      _ = try legacyClient.send(.testSendAmount, to: .recipientAddress, from: .testWallet)
    } catch {
      XCTFail("Failed sending XRP with error: \(error)")
    }
  }

  func testGetTransactionStatus_legacy() {
    do {
      let transactionStatus = try legacyClient.getTransactionStatus(for: .successfulTransactionHash)
      XCTAssertEqual(transactionStatus, .succeeded)
    } catch {
      XCTFail("Failed retrieving transaction hash with error: \(error)")
    }
  }

  func testAccountExists_legacy() {
      do {
        _ = try legacyClient.accountExists(for: Wallet.testWallet.address)
      } catch {
        XCTFail("Failed checking account existence with error: \(error)")
      }
  }
}
