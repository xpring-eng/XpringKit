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
        // GIVEN an IlpClient with a network client which will always throw a XpringIlpError.invalidAccessToken.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidAccessTokenBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidAccessTokenPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a XpringIlpError.invalidAccessToken is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: XpringIlpError.invalidAccessToken)
    }

    func testGetBalanceWithAccountNotFoundFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.notFound error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.accountNotFoundBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.accountNotFoundPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a XpringIlpError.accountNotFound error is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: XpringIlpError.accountNotFound)
    }

    func testGetBalanceWithUnauthenticatedFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.unauthenticated error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.unauthenticatedBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.unauthenticatedPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a XpringIlpError.unauthenticated error is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: XpringIlpError.unauthenticated)
    }

    func testGetBalanceWithInvalidArgumentFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.invalidArgument error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidArgumentBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidArgumentPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a XpringIlpError.invalidArgument error is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: XpringIlpError.invalidArgument)
    }

    func testGetBalanceWithInternalErrorFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.internalError error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.internalErrorBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.internalErrorPaymentNetworkClient
        )

        // WHEN the balance is requested THEN a XpringIlpError.internalError is thrown
        assertGetBalanceWithError(using: ilpClient, expectedError: XpringIlpError.internalError)
    }

    /// Helper function which calls getBalance on a DefaultIlpClient and asserts it throws the expected error
    fileprivate func assertGetBalanceWithError(using ilpClient: DefaultIlpClient, expectedError: XpringIlpError) {
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
                let ilpError = error as? XpringIlpError
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
        // GIVEN an IlpClient with a network client which will always throw a XpringIlpError.invalidAccessToken.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidAccessTokenBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidAccessTokenPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a XpringIlpErrror.invalidAccessToken error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: XpringIlpError.invalidAccessToken)
    }

    func testSendPaymentWithAccountNotFoundFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.notFound error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.accountNotFoundBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.accountNotFoundPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a XpringIlpError.accountNotFound error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: XpringIlpError.accountNotFound)
    }

    func testSendPaymentWithUnauthenticatedFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.unauthenticated error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.unauthenticatedBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.unauthenticatedPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a XpringIlpError.unauthenticated error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: XpringIlpError.unauthenticated)
    }

    func testSendPaymentWithInvalidArgumentFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.invalidArgument error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidArgumentBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidArgumentPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a XpringIlpError.invalidArgument error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: XpringIlpError.invalidArgument)
    }

    func testSendPaymentWithInternalErrorFailure() {
        // GIVEN an IlpClient with a network client which will always throw a RPCError.internalError error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.internalErrorBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.internalErrorPaymentNetworkClient
        )

        // WHEN a payment is sent THEN a XpringIlpError.internalError error is thrown
        assertSendPaymentWithError(using: ilpClient, expectedError: XpringIlpError.internalError)
    }

    /// Helper function which calls sendPayment on a DefaultIlpClient and asserts it throws the expected error
    fileprivate func assertSendPaymentWithError(using ilpClient: DefaultIlpClient, expectedError: XpringIlpError) {
        XCTAssertThrowsError(try ilpClient.sendPayment(
            .testPaymentRequest,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
                let ilpError = error as? XpringIlpError
                else {
                    XCTFail("Error thrown was not XpringIlpError")
                    return
            }
            XCTAssertEqual(ilpError, expectedError)
        }
    }
}
