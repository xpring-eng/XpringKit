import BigInt
import XCTest
import XpringKit

extension Wallet {
    /// A test wallet which contains funds.
    public static let testWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension String {
    /// The URL of the remote gRPC service.
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
//            XCTAssertEqual(transaction.meta.transactionResult.result, "tesSUCCESS")
        } catch {
            XCTFail("Failed retrieving transaction hash with error: \(error)")
        }
    }
}
