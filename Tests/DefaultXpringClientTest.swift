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
    static let feeDrops = BigUInt("15")
}

extension UInt32 {
    static let sequence: UInt32 = 2
}

extension Rpc_V1_GetAccountInfoResponse {
    static let accountInfo = Rpc_V1_GetAccountInfoResponse.with {
        let _balance = Rpc_V1_XRPDropsAmount.with {
            $0.drops = UInt64(BigUInt.balance)
        }
        $0.accountData.balance = _balance
        $0.accountData.sequence = .sequence
    }
}

extension String {
    static let transactionBlobHex = "DEADBEEF"
    static let transactionCodeSuccess = "tesSUCCESS"
    static let transactionCodeFailure = "tecFAILURE"
}

extension Rpc_V1_Fee {
    static let fee = Rpc_V1_Fee.with {
        $0.baseFee = Rpc_V1_XRPDropsAmount.with {
            $0.drops = UInt64(BigUInt.feeDrops)
        }
    }
}

extension Rpc_V1_GetFeeResponse {
    static let fee = Rpc_V1_GetFeeResponse.with {
        $0.drops = Rpc_V1_Fee.with {
            $0.baseFee = Rpc_V1_XRPDropsAmount.with {
                $0.drops = UInt64(BigUInt.feeDrops)
            }
        }
    }
}

extension Rpc_V1_GetTxResponse {
    static let transactionResult = Rpc_V1_GetTxResponse.with {
        $0.meta.transactionResult.result = "tesSUCCESS"
    }
}

extension Rpc_V1_SubmitTransactionResponse {
    static let submitTransactionResult = Rpc_V1_SubmitTransactionResponse.with {
        $0.engineResult.result = "tesSUCCESS"
    }
}

//extension Rpc_V1_LedgerSequence {
//  static let ledgerSequence = Rpc_V1_LedgerSequence.with {
//    $0.index = 12
//  }
//}
extension FakeNetworkClient {
    /// A network client that always succeeds.
    static let successfulFakeNetworkClient = FakeNetworkClient(
        accountInfoResult: .success(.accountInfo),
        feeResult: .success(.fee),
        submitTransactionResult: .success(.submitTransactionResult),
//        latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
        transactionResult: .success(.transactionResult)
    )
}

extension Rpc_V1_Transaction {
    public static let transaction = Rpc_V1_SubmitTransactionResponse()
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
        XCTAssertEqual(balance, .balance)
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
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(.transactionResult)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the balance is requested THEN the error is thrown.
        XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
    }

    // MARK: - Send
    func testSendWithSuccess() {
        // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        // WHEN XRP is sent.
        guard
            let transaction = try? xpringClient.submitTransaction(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet,
                invoiceID: nil,
                memos: nil,
                flags: nil,
                sourceTag: nil,
                accountTransactionID: nil
            )
            else {
                XCTFail("Exception should not be thrown when trying to send XRP")
                return
        }

        // THEN the engine result code is as expected.
        XCTAssertEqual(transaction.hash, Utils.toTransactionHash(transactionBlobHex: .transactionBlobHex)?.data(using: .utf8))
    }

    func testSendWithClassicAddress() {
        // GIVEN a classic address.
        guard let classicAddressComponents = Utils.decode(xAddress: .destinationAddress) else {
            XCTFail("Failed to decode X-Address.")
            return
        }
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        // WHEN XRP is sent to a classic address THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.submitTransaction(
            .sendAmount,
            to: classicAddressComponents.classicAddress,
            from: .wallet,
            invoiceID: nil,
            memos: nil,
            flags: nil,
            sourceTag: nil,
            accountTransactionID: nil
        ))
    }

    func testSendWithInvalidAddress() {
        // GIVEN a Xpring client and an invalid destination address.
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)
        let destinationAddress = "xrp"

        // WHEN XRP is sent to an invalid address THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.submitTransaction(
            .sendAmount,
            to: destinationAddress,
            from: .wallet,
            invoiceID: nil,
            memos: nil,
            flags: nil,
            sourceTag: nil,
            accountTransactionID: nil
        ))
    }

    func testSendWithAccountInfoFailure() {
        // GIVEN a Xpring client which will fail to return account info.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .failure(XpringKitTestError.mockFailure),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(.transactionResult)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.submitTransaction(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet,
            invoiceID: nil,
            memos: nil,
            flags: nil,
            sourceTag: nil,
            accountTransactionID: nil
        ))
    }

    func testSendWithFeeFailure() {
        // GIVEN a Xpring client which will fail to return a fee.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .failure(XpringKitTestError.mockFailure),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(.transactionResult)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.submitTransaction(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet,
            invoiceID: nil,
            memos: nil,
            flags: nil,
            sourceTag: nil,
            accountTransactionID: nil
        ))
    }

    func testSendWithLatestLedgerSequenceFailure() {
        // GIVEN a Xpring client which will fail to return the latest validated ledger sequence.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .failure(XpringKitTestError.mockFailure),
            transactionResult: .success(.transactionResult)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.submitTransaction(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet,
            invoiceID: nil,
            memos: nil,
            flags: nil,
            sourceTag: nil,
            accountTransactionID: nil
        ))
    }

    func testSendWithSubmitFailure() {
        // GIVEN a Xpring client which will fail to submit a transaction.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .failure(XpringKitTestError.mockFailure),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(.transactionResult)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.submitTransaction(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet,
            invoiceID: nil,
            memos: nil,
            flags: nil,
            sourceTag: nil,
            accountTransactionID: nil
        ))
    }

    func testGettransactionWithUnvalidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a failed transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = false
            $0.meta.transactionResult.result = .transactionCodeFailure
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transaction = try? xpringClient.getTx(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transaction?.meta.transactionResult.result, "tecFAILURE")
    }

    func testGettransactionWithUnvalidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a succeeded transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = false
            $0.meta.transactionResult.result = .transactionCodeSuccess
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transaction = try? xpringClient.getTx(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transaction?.meta.transactionResult.result, "tecFAILURE")
    }

    func testGettransactionWithValidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns a validated transaction and a failed transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = true
            $0.meta.transactionResult.result = .transactionCodeFailure
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transaction = try? xpringClient.getTx(for: .testTransactionHash)

        // THEN the transaction status is failed.
        XCTAssertEqual(transaction?.meta.transactionResult.result, "tesSUCCESS")
    }

    func testGettransactionWithValidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns a validated transaction and a succeeded transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = true
            $0.meta.transactionResult.result = .transactionCodeSuccess
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transaction = try? xpringClient.getTx(for: .testTransactionHash)

        // THEN the transaction status is succeeded.
        XCTAssertEqual(transaction?.meta.transactionResult.result, "tesSUCCESS")
    }

    func testGettransactionWithServerFailure() {
        // GIVEN a XpringClient which fails to return a transaction status.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfo),
            feeResult: .success(.fee),
            submitTransactionResult: .success(.submitTransactionResult),
            //      latestValidatedLedgerSequenceResult: .success(.ledgerSequence),
            transactionResult: .failure(XpringKitTestError.mockFailure)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.getTx(for: .testTransactionHash))
    }
}
