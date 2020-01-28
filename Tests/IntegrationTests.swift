import BigInt
import XCTest
import XpringKit

extension Wallet {
  /// A test wallet which contains funds.
  public static let testWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension String {
  /// The URL of the remote legacy gRPC service.
  public static let legacyRemoteURL = "grpc.xpring.tech:80"

  /// The URL of a remote rippled node with gRPC enabled.
  public static let remoteURL = "3.14.64.116:50051"

  /// An address on the chain to receive funds.
  public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

extension BigUInt {
  /// Drops of XRP to send.
  public static let drops = BigUInt(1)
}

extension TransactionHash {
  public static let successfulTransactionHash = "DFDC135AE3C8F68A1DC3959CBCFCABEA3EB91BDF7F8D22468A4F4FE9350FE8DA"
}

/// Integration tests run against a live remote client.
final class IntegrationTests: XCTestCase {
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

  func testGetTransactionStatus() {
    do {
      let transactionStatus = try client.getTransactionStatus(for: .successfulTransactionHash)
      XCTAssertEqual(transactionStatus, .succeeded)
    } catch {
      XCTFail("Failed retrieving transaction hash with error: \(error)")
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
      _ = try legacyClient.send(.drops, to: .recipientAddress, from: .testWallet)
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
}
