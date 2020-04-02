import SwiftGRPC
import XCTest
@testable import XpringKit

final class DefaultIlpClientTest: XCTestCase {

    // MARK: - Balance
    func testGetBalanceWithSuccess() {
        // GIVEN an IlpClient which will successfully return a balance from a mocked network call.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.successfulFakeNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.successfulFakeNetworkClient
        )

        // WHEN the balance is requested
        guard let balance =
            try? ilpClient.getBalance(
                for: .testAccountID,
                withAuthorization: .testAccessToken
            ) else {
              XCTFail("Exception should not be thrown when trying to get a balance")
              return
        }

        // THEN the balance is correct
        XCTAssertEqual(balance.accountID, .testAccountID)
        XCTAssertEqual(balance.assetCode, .testAssetCode)
        XCTAssertEqual(balance.assetScale, .testAssetScale)
        XCTAssertEqual(balance.clearingBalance, .testIlpBalance)
        XCTAssertEqual(balance.prepaidAmount, .testIlpBalance)
        XCTAssertEqual(balance.netBalance, .testIlpBalance + .testIlpBalance)
    }

    func testGetBalanceWithInvalidAccessTokenFailure() {
        // GIVEN an IlpClient with a network client which will always throw a IlpError.invalidAccessToken.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidAccessTokenBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidAccessTokenPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a IlpError.invalidAccessToken is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: IlpError.invalidAccessToken)
    }

    func testGetBalanceWithAccountNotFoundFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.notFound error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.accountNotFoundBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.accountNotFoundPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a IlpError.accountNotFound error is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: IlpError.accountNotFound)
    }

    func testGetBalanceWithUnauthenticatedFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.unauthenticated error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.unauthenticatedBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.unauthenticatedPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a IlpError.unauthenticated error is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: IlpError.unauthenticated)
    }

    func testGetBalanceWithInvalidArgumentFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.invalidArgument error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidArgumentBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidArgumentPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a IlpError.invalidArgument error is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: IlpError.invalidArgument)
    }

    func testGetBalanceWithInternalErrorFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.internalError error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.internalErrorBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.internalErrorPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a IlpError.internalError is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: IlpError.internalError)
    }

    /// Helper function which calls getBalance on a DefaultIlpClient and asserts it throws the expected error
    fileprivate func assertGetBalanceWithError(using ilpClient: DefaultIlpClient, expectedError: IlpError) {
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
                let ilpError = error as? IlpError
                else {
                  XCTFail("Error thrown was not mocked error")
                  return
            }
            XCTAssertEqual(ilpError, expectedError)
        }
    }

    // MARK: - Payment
    func testSendPaymentWithSuccess() {
        // GIVEN an IlpClient which will successfully return a payment response from a mocked network call.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.successfulFakeNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.successfulFakeNetworkClient
        )

        // WHEN a payment is sent
        guard let payment: PaymentResult =
            try? ilpClient.sendPayment(
                .testPaymentRequest,
                withAuthorization: .testAccessToken
            ) else {
                XCTFail("Exception should not be thrown when trying to send a payment")
                return
        }

        // THEN the payment response is correct
        XCTAssertEqual(payment.originalAmount, .testIlpSendAmount)
        XCTAssertEqual(payment.amountDelivered, .testIlpSendAmount)
        XCTAssertEqual(payment.amountSent, .testIlpSendAmount)
        XCTAssertEqual(payment.successfulPayment, true)
    }

    func testSendPaymentWithInvalidAccessTokenFailure() {
        // GIVEN an IlpClient with a network client which will always throw a IlpError.invalidAccessToken.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidAccessTokenBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidAccessTokenPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a XpringIlpErrror.invalidAccessToken error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: IlpError.invalidAccessToken)
    }

    func testSendPaymentWithAccountNotFoundFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.notFound error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.accountNotFoundBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.accountNotFoundPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a IlpError.accountNotFound error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: IlpError.accountNotFound)
    }

    func testSendPaymentWithUnauthenticatedFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.unauthenticated error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.unauthenticatedBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.unauthenticatedPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a IlpError.unauthenticated error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: IlpError.unauthenticated)
    }

    func testSendPaymentWithInvalidArgumentFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.invalidArgument error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidArgumentBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidArgumentPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a IlpError.invalidArgument error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: IlpError.invalidArgument)
    }

    func testSendPaymentWithInternalErrorFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.internalError error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.internalErrorBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.internalErrorPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a IlpError.internalError error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: IlpError.internalError)
    }

    /// Helper function which calls sendPayment on a DefaultIlpClient and asserts it throws the expected error
    fileprivate func assertSendPaymentWithError(using ilpClient: DefaultIlpClient, expectedError: IlpError) {
        XCTAssertThrowsError(try ilpClient.sendPayment(
            .testPaymentRequest,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
                let ilpError = error as? IlpError
                else {
                    XCTFail("Error thrown was not IlpError")
                    return
            }
            XCTAssertEqual(ilpError, expectedError)
        }
    }
}
