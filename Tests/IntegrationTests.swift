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
  public static let recipientAddress = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
}

extension BigUInt {
  /// Drops of XRP to send.
  public static let drops = BigUInt(1)
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
}
