import BigInt
import XCTest
@testable import XpringKit

extension Wallet {
    static let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension Address {
    static let destinationAddress = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
}

extension BigUInt {
    static let sendAmount = BigUInt(stringLiteral: "20")
    static let balance = BigUInt(stringLiteral: "1000")
}

extension UInt64 {
    static let sequence: UInt64 = 2
    static let balance: UInt64 = 1_000
    static let feeDrops: UInt64 = 15
}

extension Data {
    static let invoiceID: Data = "testInvoiceID".data(using: .utf8)!
}

extension Io_Xpring_AccountInfo {
    static let accountInfo = Io_Xpring_AccountInfo.with {
        let dropsAmount = Io_Xpring_XRPDropsAmount.with {
            $0.drops = UInt64.balance
        }
        $0.balance = dropsAmount
        $0.sequence = .sequence
    }
}

extension String {
    static let transactionBlobHex = "DEADBEEF"
    static let transactionStatusCodeSuccess = "tesSUCCESS"
    static let transactionStatusCodeFailure = "tecFAILURE"
}

extension Io_Xpring_Fee {
    static let fee = Io_Xpring_Fee.with {
        let dropsAmount = Io_Xpring_XRPDropsAmount.with {
            $0.drops = UInt64.balance
        }
        $0.amount = dropsAmount
    }
}

extension Io_Xpring_SubmitSignedTransactionResponse {
    static let submitTransactionResponse = Io_Xpring_SubmitSignedTransactionResponse.with {
        $0.transactionBlob = .transactionBlobHex
    }
}

extension Io_Xpring_LedgerSequence {
    static let ledgerSequence = Io_Xpring_LedgerSequence.with {
        $0.index = 12
    }
}

extension FakeNetworkClient {
    /// A network client that always succeeds.
    static let successfulFakeNetworkClient = FakeNetworkClient(
        accountInfoResult: .success(.accountInfo),
        feeResult: .success(.fee),
        submitSignedTransactionResult: .success(.submitTransactionResponse),
        latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
        transactionStatusResult: .success(.transactionStatus)
    )
}

extension Io_Xpring_TransactionStatus {
    public static let transactionStatus = Io_Xpring_TransactionStatus.with {
        $0.validated = true
        $0.transactionStatusCode = .transactionStatusCodeSuccess
    }
}

final class DefaultXpringClientTest: XCTestCase {
    // MARK: - Balance

    func testGetBalanceWithSuccess() {
        // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        // WHEN the balance is requested.
        guard let balance = try? xpringClient.getBalance(for: .destinationAddress) else {
            XCTFail("Exception should not be thrown when trying to get a balance")
            return
        }

        // THEN the balance is correct.
        XCTAssertEqual(balance, BigUInt.balance)
    }

    func testGetBalanceWithClassicAddress() {
        // GIVEN a classic address.
        guard let classicAddressComponents = Utils.decode(xAddress: .destinationAddress) else {
            XCTFail("Failed to decode X-Address.")
            return
        }
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        // WHEN the balance is requested THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.getBalance(for: classicAddressComponents.classicAddress))
    }

    func testGetBalanceWithFailure() {
        // GIVEN a Xpring client which will throw an error when a balance is requested.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .failure(XpringKitTestError.mockFailure),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(.transactionStatus)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the balance is requested THEN the error is thrown.
        XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
    }

    // MARK: - Send

    func testSendWithSuccess() {
        // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        // WHEN XRP is signed.
        guard
            let signedTransaction = try? xpringClient.sign(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            else {
                XCTFail("Exception should not be thrown when trying to send XRP")
                return
        }

        // WHEN XRP is sent.
        guard
            let transactionHash = try? xpringClient.send(signedTransaction)
            else {
                XCTFail("Exception should not be thrown when trying to send XRP")
                return
        }

        // THEN the engine result code is as expected.
        //    XCTAssertEqual(transactionHash, Utils.toTransactionHash(transactionBlobHex: .transactionBlobHex))
    }

    func testSendWithClassicAddress() {
        // GIVEN a classic address.
        guard let classicAddressComponents = Utils.decode(xAddress: .destinationAddress) else {
            XCTFail("Failed to decode X-Address.")
            return
        }
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        do {
            let _signedTransaction = try xpringClient.sign(
                .sendAmount,
                to: classicAddressComponents.classicAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            // WHEN a send is attempted then an error is thrown.
            XCTAssertThrowsError(try xpringClient.send(_signedTransaction))
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testSendWithInvalidAddress() {
        // GIVEN a Xpring client and an invalid destination address.
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)
        let destinationAddress = "xrp"

        do {
            let _signedTransaction = try xpringClient.sign(
                .sendAmount,
                to: destinationAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            // WHEN a send is attempted then an error is thrown.
            XCTAssertThrowsError(try xpringClient.send(_signedTransaction))
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testSendWithAccountInfoFailure() {
        // GIVEN a Xpring client which will fail to return account info.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .failure(XpringKitTestError.mockFailure),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(.transactionStatus)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        do {
            let _signedTransaction = try xpringClient.sign(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: [],
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            // WHEN a send is attempted then an error is thrown.
            XCTAssertThrowsError(try xpringClient.send(_signedTransaction))
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testSendWithFeeFailure() {
        // GIVEN a Xpring client which will fail to return a fee.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .failure(XpringKitTestError.mockFailure),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(.transactionStatus)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        do {
            let _signedTransaction = try xpringClient.sign(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: [],
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            // WHEN a send is attempted then an error is thrown.
            XCTAssertThrowsError(try xpringClient.send(_signedTransaction))
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testSendWithLatestLedgerSequenceFailure() {
        // GIVEN a Xpring client which will fail to return the latest validated ledger sequence.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .failure(XpringKitTestError.mockFailure),
            transactionStatusResult: .success(.transactionStatus)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        do {
            let _signedTransaction = try xpringClient.sign(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: [],
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            // WHEN a send is attempted then an error is thrown.
            XCTAssertThrowsError(try xpringClient.send(_signedTransaction))
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testSendWithSubmitFailure() {
        // GIVEN a Xpring client which will fail to submit a transaction.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .failure(XpringKitTestError.mockFailure),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(.transactionStatus)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        do {
            let _signedTransaction = try xpringClient.sign(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet,
                invoiceID: .invoiceID,
                memos: [],
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            // WHEN a send is attempted then an error is thrown.
            XCTAssertThrowsError(try xpringClient.send(_signedTransaction))
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testGetTransactionStatusWithUnvalidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a failed transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.transactionStatusCode = .transactionStatusCodeFailure
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transactionStatus, .pending)
    }

    func testGetTransactionStatusWithUnvalidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a succeeded transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.transactionStatusCode = .transactionStatusCodeSuccess
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transactionStatus, .pending)
    }

    func testGetTransactionStatusWithValidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns a validated transaction and a failed transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = true
            $0.transactionStatusCode = .transactionStatusCodeFailure
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is failed.
        XCTAssertEqual(transactionStatus, .failed)
    }

    func testGetTransactionStatusWithValidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns a validated transaction and a succeeded transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = true
            $0.transactionStatusCode = .transactionStatusCodeSuccess
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is succeeded.
        XCTAssertEqual(transactionStatus, .succeeded)
    }

    func testGetTransactionStatusWithServerFailure() {
        // GIVEN a XpringClient which fails to return a transaction status.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitSignedTransactionResult: .success(.submitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionStatusResult: .failure(XpringKitTestError.mockFailure)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.getTransactionStatus(for: .testTransactionHash))
    }
}
