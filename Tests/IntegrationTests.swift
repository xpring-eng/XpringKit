import BigInt
import XCTest
import XpringKit

extension Wallet {
    /// A test wallet which contains funds.
    public static let testWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension String {
    /// The URL of the remote gRPC service.
    public static let legacyURL = "grpc.xpring.tech:80"
    public static let remoteURL = "142.93.73.197:88"

    /// An address on the chain to receive funds.
    public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

extension BigUInt {
    /// Drops of XRP to send.
    public static let drops = BigUInt(1)
}

extension TransactionHash {
    public static let successfulTransactionHash = "8744AC464E08B4539E508D83E668C9E1D50E3A2FC415D71813C9F9EE0301B77D"

}

/// Integration tests run against a live remote client.
final class IntegrationTests: XCTestCase {
    private let client = XpringClient(grpcURL: .remoteURL, useNewBuffers: true)
    private let legacyClient = XpringClient(grpcURL: .legacyURL)

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
            XCTFail("Failed retrieving transaction hash with error: \(error)")
        }
    }

    // LEGACY

    func testLegacyGetBalance() {
        do {
            _ = try legacyClient.getBalance(for: Wallet.testWallet.address)
        } catch {
            XCTFail("Failed retrieving balance with error: \(error)")
        }
    }

    func testLegacySendXRP() {
        do {
            _ = try legacyClient.send(.drops, to: .recipientAddress, from: .testWallet)
        } catch {
            XCTFail("Failed sending XRP with error: \(error)")
        }
    }

    func testLegacyGetTransactionStatus() {
        do {
            let transactionStatus = try legacyClient.getTransactionStatus(for: .successfulTransactionHash)
            XCTAssertEqual(transactionStatus, .succeeded)
        } catch {
            XCTFail("Failed retrieving transaction hash with error: \(error)")
        }
    }
}
