import BigInt
import XCTest
import XpringKit

extension Wallet {
    /// A test wallet which contains funds.
    public static let testWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension String {
    /// The URL of the remote gRPC service.
    public static let remoteURL = "127.0.0.1:500051"

    /// An address on the chain to receive funds.
    public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

extension BigUInt {
    /// Drops of XRP to send.
    public static let drops = BigUInt(1)
}

extension TransactionHash {
    public static let successfulTransactionHash = "9A88C8548E03958FD97AF44AE5A8668896D195A70CF3FF3CB8E57096AA717135"
}

extension String {
    static let invoiceID: String = "InvoiceID"
    static let flags: String = "0000000000"
    static let accountTxID: String = "accountTxID"
}

extension UInt32 {
    static let sourceTag: UInt32 = UInt32("")!
}

//extension Rpc_V1_Memo {
//    static let memos: [Rpc_V1_Memo]? = []
//}
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

    func testSubmitXRP() {
        do {
            _ = try client.submitTransaction(
                .drops,
                to: .recipientAddress,
                from: .testWallet,
                invoiceID: String.invoiceID.data(using: .utf8),
                memos: nil,
                flags: UInt32(.flags),
                sourceTag: nil,
                accountTransactionID: String.accountTxID.data(using: .utf8)
            )
        } catch {
            XCTFail("Failed sending XRP with error: \(error)")
        }
    }

    func testGetTx() {
        do {
            let transaction = try client.getTx(for: .successfulTransactionHash)
            XCTAssertEqual(transaction.meta.transactionResult.result, "tesSucceed")
        } catch {
            XCTFail("Failed retrieving transaction hash with error: \(error)")
        }
    }
}
