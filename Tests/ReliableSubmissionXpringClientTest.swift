import BigInt
import XCTest
@testable import XpringKit

final class ReliableSubmissionClientTest: XCTestCase {
    let defaultBalanceValue = BigUInt(0)
    let defaultTransactionValue = Rpc_V1_GetTxResponse.with {
        $0.validated = true
        $0.meta.transactionResult = Rpc_V1_TransactionResult.with {
            $0.result = "tesSuccess"
        }
    }
    let defaultSendValue = Rpc_V1_SubmitTransactionResponse.with {
        $0.hash = "DEADBEEF".data(using: .utf8)!
    }
    //  let defaultLastestValidatedLedgerValue: UInt32 = 10
    let defaultRawTransactionValue = Rpc_V1_GetTxResponse.with {
        $0.validated = true
        $0.meta.transactionResult = Rpc_V1_TransactionResult.with {
            $0.result = "tesSuccess"
        }
//        $0.lastLedgerSequence = 100
    }

    var fakeXpringClient: FakeXpringClient!
    var reliableSubmissionClient: ReliableSubmissionXpringClient!

    override func setUp() {
        fakeXpringClient = FakeXpringClient(
            getBalanceValue: defaultBalanceValue,
            transactionValue: defaultTransactionValue,
            sendValue: defaultSendValue,
            //      latestValidatedLedgerValue: defaultLastestValidatedLedgerValue,
            rawTransactionValue: defaultRawTransactionValue
        )

        reliableSubmissionClient = ReliableSubmissionXpringClient(decoratedClient: fakeXpringClient)
    }

    func testGetBalance() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN a balance is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getBalance(for: .testAddress), defaultBalanceValue)
    }

    func testGettransaction() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN a transaction status is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getTx(for: .testTransactionHash), defaultTransactionValue)
    }

//    func testGetLatestValidatedLedgerSequence() {
//        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN the latest ledger sequence is retrieved THEN the result is returned unaltered.
//        XCTAssertEqual(try? reliableSubmissionClient.getLatestValidatedLedgerSequence(), defaultLastestValidatedLedgerValue)
//    }
    func testGetRawtransaction() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN a raw transaction status is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getRawTx(for: .testTransactionHash), defaultRawTransactionValue)
    }

    func testSendWithExpiredLedgerSequenceAndUnvalidatedTransaction() throws {
        // GIVEN A ledger sequence number that will increment in 60s.
        let lastLedgerSequence: UInt32 = 20
        fakeXpringClient.rawTransactionValue = Rpc_V1_GetTxResponse.with {
            $0.validated = false
//            $0.lastLedgerSequence = lastLedgerSequence
            $0.meta.transactionResult = Rpc_V1_TransactionResult.with {
                $0.result = "tesSuccess"
            }
        }
        //    runAfterOneSecond({ self.fakeXpringClient.latestValidatedLedgerValue = lastLedgerSequence + 1 })
        // WHEN a reliable send is submitted
        let expectation = XCTestExpectation(description: "Send returned")
        do {
            _ = try reliableSubmissionClient.submitTransaction(
                BigUInt(10),
                to: .testAddress,
                from: .testWallet,
                invoiceID: "InvoiceID".data(using: .utf8),
                memos: nil,
                flags: UInt32("000000000"),
                sourceTag: nil,
                accountTransactionID: nil
            )
            expectation.fulfill()
        } catch {
            XCTFail("Caught unexpected error while calling `send`: \(error)")
        }

        // THEN the function returns
        self.wait(for: [ expectation ], timeout: 10)
    }

    func testSendWithUnexpiredLedgerSequenceAndValidatedTransaction() throws {
        // GIVEN A ledger sequence number that will increment in 60s.
        //    let lastLedgerSequence: UInt32 = 20
        fakeXpringClient.rawTransactionValue = Rpc_V1_GetTxResponse.with {
            $0.validated = false
            $0.meta.transactionResult = Rpc_V1_TransactionResult.with {
                $0.result = "tesSuccess"
            }
        }
        runAfterOneSecond({ self.fakeXpringClient.rawTransactionValue.validated = true })

        // WHEN a reliable send is submitted
        let expectation = XCTestExpectation(description: "Send returned")
        do {
            _ = try reliableSubmissionClient.submitTransaction(
                BigUInt(10),
                to: .testAddress,
                from: .testWallet,
                invoiceID: "InvoiceID".data(using: .utf8),
                memos: nil,
                flags: UInt32("000000000"),
                sourceTag: nil,
                accountTransactionID: nil
            )
            expectation.fulfill()
        } catch {
            XCTFail("Caught unexpected error while calling `send`: \(error)")
        }

        // THEN the function returns
        self.wait(for: [ expectation ], timeout: 10)
    }

    func testSendWithNoLastLedgerSequence() throws {
        // GIVEN a `ReliableSubmissionXpringClient` decorating a `FakeXpringClient` which will return a transaction that did not have a last ledger sequence attached.
        fakeXpringClient.rawTransactionValue = Rpc_V1_GetTxResponse.with {
            $0.validated = false
            $0.meta.transactionResult = Rpc_V1_TransactionResult.with {
                $0.result = "tesSuccess"
            }
        }

        // WHEN a reliable send is submitted THEN an error is thrown.
        XCTAssertThrowsError(try reliableSubmissionClient.submitTransaction(
                BigUInt(10),
                to: .testAddress,
                from: .testWallet,
                invoiceID: "InvoiceID".data(using: .utf8),
                memos: nil,
                flags: UInt32("000000000"),
                sourceTag: nil,
                accountTransactionID: nil
            )
        )
    }

    // MARK: - Helpers
    func runAfterOneSecond(_ task: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: (.now() + 1)) { task() }
    }
}
