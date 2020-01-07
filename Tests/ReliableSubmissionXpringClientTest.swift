import BigInt
import XCTest
@testable import XpringKit

final class ReliableSubmissionClientTest: XCTestCase {
    let defaultBalanceValue = BigUInt(0)
    let defaultTransactionStatusValue: TransactionStatus = .succeeded
    let defaultSendValue = "DEADBEEF"
    let defaultSignedTransaction = Io_Xpring_SignedTransaction.with {
        $0.transaction = Io_Xpring_Transaction.with {
            $0.account = Io_Xpring_AccountAddress.with {
                $0.address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
            }
            $0.fee = Io_Xpring_XRPDropsAmount.with {
                $0.drops = UInt64(12)
            }
            $0.sequence = UInt32(40)
            $0.payment = Io_Xpring_Payment.with {
                $0.destination = Io_Xpring_AccountAddress.with {
                    $0.address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
                }
                $0.amount = Io_Xpring_CurrencyAmount.with {
                    $0.xrpAmount = Io_Xpring_XRPDropsAmount.with {
                        $0.drops = UInt64(1)
                    }
                }
            }
            //        if let _memos = memos {
            //            $0.memos = _memos
            //        }
            //        if let _flags = flags {
            //            $0.flags = _flags
            //        }
            //        if let _sourceTag = sourceTag {
            //            $0.sourceTag = _sourceTag
            //        }
            //        if let _accountTransactionID = accountTransactionID {
            //            $0.accountTransactionID = _accountTransactionID
            //        }
            // Format For Hex
            //            $0.signingPublicKey = sourceWallet.publicKey
            //        $0.lastLedgerSequence = lastValidatedLedgerSequence + ledgerSequenceMargin
        }
    }
    let defaultLastestValidatedLedgerValue: UInt32 = 10
    let defaultRawTransactionStatusValue = Io_Xpring_TransactionStatus.with {
        $0.validated = true
        $0.transactionStatusCode = "tesSuccess"
        $0.lastLedgerSequence = 100
    }

    var fakeXpringClient: FakeXpringClient!
    var reliableSubmissionClient: ReliableSubmissionXpringClient!

    override func setUp() {
        fakeXpringClient = FakeXpringClient(
            getBalanceValue: defaultBalanceValue,
            transactionStatusValue: defaultTransactionStatusValue,
            sendValue: defaultSendValue,
            signedTransaction: defaultSignedTransaction,
            latestValidatedLedgerValue: defaultLastestValidatedLedgerValue,
            rawTransactionStatusValue: defaultRawTransactionStatusValue
        )

        reliableSubmissionClient = ReliableSubmissionXpringClient(decoratedClient: fakeXpringClient)
    }

    func testGetBalance() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN a balance is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getBalance(for: .testAddress), defaultBalanceValue)
    }

    func testGetTransactionStatus() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN a transaction status is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getTransactionStatus(for: .testTransactionHash), defaultTransactionStatusValue)
    }

    func testGetLatestValidatedLedgerSequence() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN the latest ledger sequence is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getLatestValidatedLedgerSequence(), defaultLastestValidatedLedgerValue)
    }

    func testGetRawTransactionStatus() {
        // GIVEN a `ReliableSubmissionClient` decorating a FakeXpringClient WHEN a raw transaction status is retrieved THEN the result is returned unaltered.
        XCTAssertEqual(try? reliableSubmissionClient.getRawTransactionStatus(for: .testTransactionHash), defaultRawTransactionStatusValue)
    }

    func testSendWithExpiredLedgerSequenceAndUnvalidatedTransaction() throws {
        // GIVEN A ledger sequence number that will increment in 60s.
        let lastLedgerSequence: UInt32 = 20
        fakeXpringClient.rawTransactionStatusValue = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.lastLedgerSequence = lastLedgerSequence
            $0.transactionStatusCode = "tesSuccess"
        }
        runAfterOneSecond({ self.fakeXpringClient.latestValidatedLedgerValue = lastLedgerSequence + 1 })

        // WHEN a reliable send is submitted
        let expectation = XCTestExpectation(description: "Send returned")
        do {
            let signedTransaction = try reliableSubmissionClient.sign(
                BigUInt(10),
                to: .testAddress,
                from: .testWallet,
                invoiceID: nil,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            _ = try reliableSubmissionClient.send(signedTransaction)
            expectation.fulfill()
        } catch {
            XCTFail("Caught unexpected error while calling `send`: \(error)")
        }

        // THEN the function returns
        self.wait(for: [ expectation ], timeout: 10)
    }

    func testSendWithUnexpiredLedgerSequenceAndValidatedTransaction() throws {
        // GIVEN A ledger sequence number that will increment in 60s.
        let lastLedgerSequence: UInt32 = 20
        fakeXpringClient.rawTransactionStatusValue = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.lastLedgerSequence = lastLedgerSequence
            $0.transactionStatusCode = "tesSuccess"
        }
        runAfterOneSecond({ self.fakeXpringClient.rawTransactionStatusValue.validated = true })

        // WHEN a reliable send is submitted
        let expectation = XCTestExpectation(description: "Send returned")
        do {
            let signedTransaction = try reliableSubmissionClient.sign(
                BigUInt(10),
                to: .testAddress,
                from: .testWallet,
                invoiceID: nil,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            _ = try reliableSubmissionClient.send(signedTransaction)
            expectation.fulfill()
        } catch {
            XCTFail("Caught unexpected error while calling `send`: \(error)")
        }

        // THEN the function returns
        self.wait(for: [ expectation ], timeout: 10)
    }

    func testSendWithNoLastLedgerSequence() throws {
        // GIVEN a `ReliableSubmissionXpringClient` decorating a `FakeXpringClient` which will return a transaction that did not have a last ledger sequence attached.
        fakeXpringClient.rawTransactionStatusValue = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.transactionStatusCode = "tesSuccess"
        }

        do {
            let signedTransaction = try reliableSubmissionClient.sign(
                BigUInt(10),
                to: .testAddress,
                from: .testWallet,
                invoiceID: nil,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            _ = try reliableSubmissionClient.send(signedTransaction)
        } catch {
            XCTFail("Caught unexpected error while calling `send`: \(error)")
        }
    }

    // MARK: - Helpers

    func runAfterOneSecond(_ task: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: (.now() + 1)) { task() }
    }
}
