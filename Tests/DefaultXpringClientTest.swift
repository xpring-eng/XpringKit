import BigInt
import XCTest
@testable import XpringKit

// TODO(keefer): Refactor these objects to the Helpers/TestObjects file.
extension Wallet {
    static let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
}

extension Address {
    static let destinationAddress = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
}

extension BigUInt {
    static let sendAmount = BigUInt(stringLiteral: "20")
    static let balance = BigUInt(stringLiteral: "1000")
    static let feeResponseDrops = BigUInt("15")
}

extension UInt32 {
    static let sequence: UInt32 = 2
}

extension String {
    static let transactionBlobHex = "CA528085F95335027A8D8555E685500C5B3E325AAB22AA0BCB56605CDF97B1C8"
    static let transactionCodeSuccess = "tesSUCCESS"
    static let transactionCodeFailure = "tecFAILURE"
}

extension Rpc_V1_GetAccountInfoResponse {
    static let accountInfoResponse = Rpc_V1_GetAccountInfoResponse.with {
        let _balance = Rpc_V1_XRPDropsAmount.with {
            $0.drops = UInt64(BigUInt.balance)
        }
        $0.accountData.balance = _balance
        $0.accountData.sequence = .sequence
    }
}

extension Rpc_V1_GetFeeResponse {
    static let feeResponse = Rpc_V1_GetFeeResponse.with {
        $0.drops = Rpc_V1_Fee.with {
            $0.baseFee = Rpc_V1_XRPDropsAmount.with {
                $0.drops = UInt64(BigUInt.feeResponseDrops)
            }
        }
    }
}

extension Rpc_V1_GetTxResponse {
    static let transactionResponse = Rpc_V1_GetTxResponse.with {
        $0.meta.transactionResult.result = "tesSUCCESS"
    }
}

extension Rpc_V1_SubmitTransactionResponse {
    static let submitTransactionResponse = Rpc_V1_SubmitTransactionResponse.with {
        $0.engineResult.result = "tesSUCCESS"
    }
}

extension FakeNetworkClient {
    /// A network client that always succeeds.
    static let successfulFakeNetworkClient = FakeNetworkClient(
        accountInfoResult: .success(.accountInfoResponse),
        feeResult: .success(.feeResponse),
        submitTransactionResult: .success(.submitTransactionResponse),
        transactionResult: .success(.transactionResponse)
    )
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
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(.transactionResponse)
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
            let transactionHash = try? xpringClient.send(
                .sendAmount,
                to: .destinationAddress,
                from: .wallet)
            else {
                XCTFail("Exception should not be thrown when trying to send XRP")
                return
        }

        // THEN the engine result code is as expected.
        XCTAssertEqual(transactionHash, .transactionBlobHex)
    }

    func testSendWithClassicAddress() {
        // GIVEN a classic address.
        guard let classicAddressComponents = Utils.decode(xAddress: .destinationAddress) else {
            XCTFail("Failed to decode X-Address.")
            return
        }
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

        // WHEN XRP is sent to a classic address THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .sendAmount,
            to: classicAddressComponents.classicAddress,
            from: .wallet
            ))
    }

    func testSendWithInvalidAddress() {
        // GIVEN a Xpring client and an invalid destination address.
        let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)
        let destinationAddress = "xrp"

        // WHEN XRP is sent to an invalid address THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .sendAmount,
            to: destinationAddress,
            from: .wallet
            ))
    }

    func testSendWithAccountInfoFailure() {
        // GIVEN a Xpring client which will fail to return account info.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .failure(XpringKitTestError.mockFailure),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(.transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet
            ))
    }

    func testSendWithFeeFailure() {
        // GIVEN a Xpring client which will fail to return a feeResponse.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .failure(XpringKitTestError.mockFailure),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(.transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet
            ))
    }

    func testSendWithSubmitFailure() {
        // GIVEN a Xpring client which will fail to submit a transaction.
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .failure(XpringKitTestError.mockFailure),
            transactionResult: .success(.transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN a send is attempted then an error is thrown.
        XCTAssertThrowsError(try xpringClient.send(
            .sendAmount,
            to: .destinationAddress,
            from: .wallet
            ))
    }

    func testGetTransactionStatusWithUnvalidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a failed transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = false
            $0.meta.transactionResult.result = .transactionCodeFailure
            $0.meta.transactionResult.resultType = .tec
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transactionStatus, .pending)
    }

    func testGetTransactionStatusWithUnvalidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns an unvalidated transaction and a succeeded transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = false
            $0.meta.transactionResult.result = .transactionCodeSuccess
            $0.meta.transactionResult.resultType = .tes
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is pending.
        XCTAssertEqual(transactionStatus, .pending)
    }

    func testGetTransactionStatusWithValidatedTransactionAndFailureCode() {
        // GIVEN a XpringClient which returns a validated transaction and a failed transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = true
            $0.meta.transactionResult.result = .transactionCodeFailure
            $0.meta.transactionResult.resultType = .tec
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(transactionResponse)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved.
        let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

        // THEN the transaction status is failed.
        XCTAssertEqual(transactionStatus, .failed)
    }

    func testGetTransactionStatusWithValidatedTransactionAndSuccessCode() {
        // GIVEN a XpringClient which returns a validated transaction and a succeeded transaction status code.
        let transactionResponse = Rpc_V1_GetTxResponse.with {
            $0.validated = true
            $0.meta.transactionResult.result = .transactionCodeSuccess
            $0.meta.transactionResult.resultType = .tes
        }
        let networkClient = FakeNetworkClient(
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .success(transactionResponse)
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
            accountInfoResult: .success(.accountInfoResponse),
            feeResult: .success(.feeResponse),
            submitTransactionResult: .success(.submitTransactionResponse),
            transactionResult: .failure(XpringKitTestError.mockFailure)
        )
        let xpringClient = DefaultXpringClient(networkClient: networkClient)

        // WHEN the transaction status is retrieved THEN an error is thrown.
        XCTAssertThrowsError(try xpringClient.getTransactionStatus(for: .testTransactionHash))
    }
}
