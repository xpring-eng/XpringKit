import XCTest
import XpringKit

extension String {
  /// The URL of the remote legacy gRPC service.
  public static let legacyRemoteURL = "grpc.xpring.tech:80"

  /// The URL of a remote rippled node with gRPC enabled.
  public static let remoteURL = "test.xrp.xpring.io:50051"

  /// An address on the chain to receive funds.
  public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

extension TransactionHash {
  public static let successfulTransactionHash = "A040256A283FA2DC1E732AF70D24DC289E6BE8B9782917F0A7FDCB23D0B48F70"
}

/// Integration tests run against a live remote client.
final class XRPClientIntegrationTests: XCTestCase {
  private let legacyClient = XRPClient(grpcURL: .legacyRemoteURL, useNewProtocolBuffers: false)
  private let client = XRPClient(grpcURL: .remoteURL, useNewProtocolBuffers: true)

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
