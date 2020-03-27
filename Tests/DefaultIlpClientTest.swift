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
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidAccessTokenBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidAccessTokenPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
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
            XCTAssertEqual(ilpError, XpringIlpError.invalidAccessToken)
        }
    }

    func testGetBalanceWithAccountNotFoundFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.accountNotFoundBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.accountNotFoundPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
              let ilpError = error as? XpringIlpError
                else {
                  XCTFail("Error thrown was not XpringIlpError")
                  return
            }
            XCTAssertEqual(ilpError, XpringIlpError.accountNotFound)
        }
    }

    func testGetBalanceWithUnauthenticatedFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.unauthenticatedBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.unauthenticatedPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
              let ilpError = error as? XpringIlpError
                else {
                  XCTFail("Error thrown was not XpringIlpError")
                  return
            }
            XCTAssertEqual(ilpError, XpringIlpError.unauthenticated)
        }
    }

    func testGetBalanceWithInvalidArgumentFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidArgumentBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidArgumentPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
              let ilpError = error as? XpringIlpError
                else {
                  XCTFail("Error thrown was not XpringIlpError")
                  return
            }
            XCTAssertEqual(ilpError, XpringIlpError.invalidArgument)
        }
    }

    func testGetBalanceWithInternalErrorFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.internalErrorBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.internalErrorPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
              let ilpError = error as? XpringIlpError
                else {
                  XCTFail("Error thrown was not XpringIlpError")
                  return
            }
            XCTAssertEqual(ilpError, XpringIlpError.internalError)
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
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidAccessTokenBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidAccessTokenPaymentNetworkClient
        )

        // WHEN a payment is sent THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.sendPayment(
            .testPaymentRequest,
            withAuthorization: .testAccessToken
        ), "Exception not thrown") { error in
            guard
                let ilpError = error as? XpringIlpError
                else {
                  XCTFail("Error thrown was not mocked error")
                  return
            }
            XCTAssertEqual(ilpError, XpringIlpError.invalidAccessToken)
        }
    }

    func testSendPaymentWithAccountNotFoundFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.accountNotFoundBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.accountNotFoundPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
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
            XCTAssertEqual(ilpError, XpringIlpError.accountNotFound)
        }
    }

    func testSendPaymentWithUnauthenticatedFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.unauthenticatedBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.unauthenticatedPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
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
            XCTAssertEqual(ilpError, XpringIlpError.unauthenticated)
        }
    }

    func testSendPaymentWithInvalidArgumentFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.invalidArgumentBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.invalidArgumentPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
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
            XCTAssertEqual(ilpError, XpringIlpError.invalidArgument)
        }
    }

    func testSendPaymentWithInternalErrorFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let ilpClient = DefaultIlpClient(
            balanceNetworkClient: FakeIlpBalanceNetworkClient.internalErrorBalanceNetworkClient,
            paymentNetworkClient: FakeIlpPaymentNetworkClient.internalErrorPaymentNetworkClient
        )

        // WHEN the balance is requested THEN an error is thrown
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
            XCTAssertEqual(ilpError, XpringIlpError.internalError)
        }
    }
}
