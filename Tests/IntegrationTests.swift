import BigInt
import XCTest
import XpringKit

extension Wallet {
  /// A test wallet which contains funds.
  public static let testWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension String {
  /// The URL of the remote gRPC service.
  public static let remoteURL = "grpc.xpring.tech:80"

  /// An address on the chain to receive funds.
  public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

extension BigUInt {
  /// Drops of XRP to send.
  public static let drops = BigUInt(1)
}

extension TransactionHash {
  public static let successfulTransactionHash = "2CBBD2523478848DA256F8EBFCBD490DD6048A4A5094BF8E3034F57EA6AA0522"
}

/// Integration tests run against a live remote client.
final class IntegrationTests: XCTestCase {
  private let client = XpringClient(grpcURL: .remoteURL)

  func testGetBalance() {
    do {
      _ = try client.getBalance(for: Wallet.testWallet.address)
    } catch {
      XCTFail("Failed retrieving balance with error: \(error)")
    }
  }

  func testSendXRP() {
    do {
      _ = try client.send(.drops, to: .recipientAddress, from: .testWallet)
    } catch {
      XCTFail("Failed sending XRP with error: \(error)")
    }
  }
  
  func testGetTransactionStatus() {
    do {
      let transactionStatus = try client.getTransactionStatus(for: .successfulTransactionHash)
      XCTAssertEqual(transactionStatus, .succeeded)
    } catch {
      XCTFail("Failed retrieving transaction hash with error: \(error)");
    }
  }
}
