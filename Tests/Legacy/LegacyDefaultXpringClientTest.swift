import BigInt
import XCTest
@testable import XpringKit

// TODO(keefer): Refactor these objects to the Helpers/TestObjects file.
extension Wallet {
    static let legacyWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension Address {
    static let legacyDestinationAddress = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
}

extension BigUInt {
    static let legacySendAmount = BigUInt(stringLiteral: "20")
    static let legacyBalance = BigUInt(stringLiteral: "1000")
}

extension UInt64 {
    static let legacySequence: UInt64 = 2
}

extension Io_Xpring_AccountInfo {
    static let legacyAccountInfo = Io_Xpring_AccountInfo.with {
        $0.balance = Io_Xpring_XRPAmount.with {
            $0.drops = String(.legacyBalance)
        }
        $0.sequence = .legacySequence
    }
}

extension String {
    static let legacyFeeDrops = "15"
    static let legacyTansactionBlobHex = "DEADBEEF"
    static let legacyTransactionStatusCodeSuccess = "tesSUCCESS"
    static let legacyTransactionStatusCodeFailure = "tecFAILURE"
}

extension Io_Xpring_Fee {
    static let legacyFee = Io_Xpring_Fee.with {
        $0.amount = Io_Xpring_XRPAmount.with {
            $0.drops = .legacyFeeDrops
        }
    }
}

extension Io_Xpring_SubmitSignedTransactionResponse {
    static let legacySubmitTransactionResponse = Io_Xpring_SubmitSignedTransactionResponse.with {
        $0.transactionBlob = .legacyTansactionBlobHex
    }
}

extension Io_Xpring_LedgerSequence {
    static let legacyLedgerSequence = Io_Xpring_LedgerSequence.with {
        $0.index = 12
    }
}

extension Io_Xpring_TransactionStatus {
    public static let legacyTransactionStatus = Io_Xpring_TransactionStatus.with {
        $0.validated = true
        $0.transactionStatusCode = .legacyTransactionStatusCodeSuccess
    }
}

extension LegacyFakeNetworkClient {
    /// A network client that always succeeds.
    static let successfulFakeNetworkClient = LegacyFakeNetworkClient(
        accountInfoResult: .success(.legacyAccountInfo),
        feeResult: .success(.legacyFee),
        submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
        latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
        transactionStatusResult: .success(.legacyTransactionStatus)
    )
}

final class LegacyDefaultXpringClientTest: XCTestCase {
    // MARK: - Balance

    func testGetBalanceWithSuccess() {
        // GIVEN a Xpring client which will successfully return a legacyBalance from a mocked network call.
        let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

        // WHEN the legacyBalance is requested.
        guard let legacyBalance = try? xpringClient.getBalance(for: .legacyDestinationAddress) else {
            XCTFail("Exception should not be thrown when trying to get a legacyBalance")
            return
        }

        // THEN the legacyBalance is correct.
        XCTAssertEqual(legacyBalance, .legacyBalance)
    }

    func testGetBalanceWithClassicAddress() {
        // GIVEN a classic address.
        guard let classicAddressComponents = Utils.decode(xAddress: .legacyDestinationAddress) else {
            XCTFail("Failed to decode X-Address.")
            return
        }
        let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

        // WHEN the legacyBalance is requested THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.getBalance(for: classicAddressComponents.classicAddress))
    }

    func testGetBalanceWithFailure() {
        // GIVEN a Xpring client which will throw an error when a legacyBalance is requested.
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .failure(XpringKitTestError.mockFailure),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(.legacyTransactionStatus)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN the legacyBalance is requested THEN the error is thrown.
        XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
    }

    // MARK: - Send

    func testSendWithSuccess() {
        // GIVEN a Xpring client which will successfully return a legacyBalance from a mocked network call.
        let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

        // WHEN XRP is sent.
        guard
            let transactionHash = try? xpringClient.send(
                .legacySendAmount,
                to: .legacyDestinationAddress,
                from: .legacyWallet)
            else {
                XCTFail("Exception should not be thrown when trying to send XRP")
                return
        }

        // THEN the engine result code is as expected.
        XCTAssertEqual(transactionHash, Utils.toTransactionHash(transactionBlobHex: .legacyTansactionBlobHex))
    }

    func testSendWithClassicAddress() {
        // GIVEN a classic address.
        guard let classicAddressComponents = Utils.decode(xAddress: .legacyDestinationAddress) else {
            XCTFail("Failed to decode X-Address.")
            return
        }
        let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

        // WHEN XRP is sent to a classic address THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .legacySendAmount,
            to: classicAddressComponents.classicAddress,
            from: .legacyWallet
            ))
    }

    func testSendWithInvalidAddress() {
        // GIVEN a Xpring client and an invalid destination address.
        let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)
        let legacyDestinationAddress = "xrp"

        // WHEN XRP is sent to an invalid address THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .legacySendAmount,
            to: legacyDestinationAddress,
            from: .legacyWallet
            ))
    }

    func testSendWithAccountInfoFailure() {
        // GIVEN a Xpring client which will fail to return account info.
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .failure(XpringKitTestError.mockFailure),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(.legacyTransactionStatus)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .legacySendAmount,
            to: .legacyDestinationAddress,
            from: .legacyWallet
            ))
    }

    func testSendWithFeeFailure() {
        // GIVEN a Xpring client which will fail to return a legacyFee.
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .failure(XpringKitTestError.mockFailure),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(.legacyTransactionStatus)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .legacySendAmount,
            to: .legacyDestinationAddress,
            from: .legacyWallet
            ))
    }

    func testSendWithLatestLedgerSequenceFailure() {
        // GIVEN a Xpring client which will fail to return the latest validated ledger legacySequence.
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .failure(XpringKitTestError.mockFailure),
            transactionStatusResult: .success(.legacyTransactionStatus)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(.legacySendAmount, to: .legacyDestinationAddress, from: .legacyWallet))
    }

    func testSendWithSubmitFailure() {
        // GIVEN a Xpring client which will fail to submit a transaction.
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .failure(XpringKitTestError.mockFailure),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(.legacyTransactionStatus)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .legacySendAmount,
            to: .legacyDestinationAddress,
            from: .legacyWallet
            ))
    }

    func testGetTransactionStatusWithUnvalidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a failed transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.transactionStatusCode = .legacyTransactionStatusCodeFailure
        }
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transactionStatus, .pending)
    }

    func testGetTransactionStatusWithUnvalidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a succeeded transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = false
            $0.transactionStatusCode = .legacyTransactionStatusCodeSuccess
        }
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transactionStatus, .pending)
    }

    func testGetTransactionStatusWithValidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns a validated transaction and a failed transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = true
            $0.transactionStatusCode = .legacyTransactionStatusCodeFailure
        }
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is failed.
        XCTAssertEqual(transactionStatus, .failed)
    }

    func testGetTransactionStatusWithValidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns a validated transaction and a succeeded transaction status code.
        let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
            $0.validated = true
            $0.transactionStatusCode = .legacyTransactionStatusCodeSuccess
        }
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .success(transactionStatusResponse)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is succeeded.
        XCTAssertEqual(transactionStatus, .succeeded)
    }

    func testGetTransactionStatusWithServerFailure() {
        // GIVEN a XpringClient which fails to return a transaction status.
        let networkClient = LegacyFakeNetworkClient(
            accountInfoResult: .success(.legacyAccountInfo),
            feeResult: .success(.legacyFee),
            submitSignedTransactionResult: .success(.legacySubmitTransactionResponse),
            latestValidatedLedgerSequenceResult: .success(.legacyLedgerSequence),
            transactionStatusResult: .failure(XpringKitTestError.mockFailure)
        )
        let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.getTransactionStatus(for: .testTransactionHash))
    }
}
