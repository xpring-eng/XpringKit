import BigInt
import XCTest
import XpringKit

extension Wallet {
  /// A test wallet which contains funds.
  public static let legacyTestWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension String {
  /// The URL of the remote gRPC service.
  public static let legacyRemoteURL = "grpc.xpring.tech:80"

  /// An address on the chain to receive funds.
  public static let legacyRecipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

extension BigUInt {
  /// Drops of XRP to send.
  public static let legacyDrops = BigUInt(1)
}

extension TransactionHash {
  public static let legacySuccessfulTransactionHash = "9A88C8548E03958FD97AF44AE5A8668896D195A70CF3FF3CB8E57096AA717135"
}

/// Integration tests run against a live remote client.
final class LegacyIntegrationTests: XCTestCase {
  private let client = LegacyXpringClient(grpcURL: .legacyRemoteURL)

  func testGetBalance() {
    do {
      _ = try client.getBalance(for: Wallet.legacyTestWallet.address)
    } catch {
      XCTFail("Failed retrieving balance with error: \(error)")
    }
  }

  func testSendXRP() {
    do {
      _ = try client.send(.legacyDrops, to: .legacyRecipientAddress, from: .legacyTestWallet)
    } catch {
      XCTFail("Failed sending XRP with error: \(error)")
    }
  }

  func testGetTransactionStatus() {
    do {
      let transactionStatus = try client.getTransactionStatus(for: .legacySuccessfulTransactionHash)
      XCTAssertEqual(transactionStatus, .succeeded)
    } catch {
      XCTFail("Failed retrieving transaction hash with error: \(error)")
    }
  }
}
