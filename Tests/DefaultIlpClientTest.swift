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
        guard let balance: Org_Interledger_Stream_Proto_GetBalanceResponse =
            try? ilpClient.getBalance(
                for: .testAccountID,
                withAuthorization: .testBearerToken
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
        XCTAssertEqual(balance.netBalance, .testIlpBalance)
    }

    func testGetBalanceWithFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let balanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(XpringKitTestError.mockFailure))
        let paymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(XpringKitTestError.mockFailure))
        let ilpClient = DefaultIlpClient(balanceNetworkClient: balanceNetworkClient, paymentNetworkClient: paymentNetworkClient)

        // WHEN the balance is requested THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.getBalance(
            for: .testAccountID,
            withAuthorization: .testBearerToken
        ), "Exception not thrown") { error in
            guard
              let _ = error as? XpringKitTestError
                else {
                  XCTFail("Error thrown was not mocked error")
                  return
            }
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
        guard let payment: Org_Interledger_Stream_Proto_SendPaymentResponse =
            try? ilpClient.sendPayment(
                .testIlpSendAmount,
                to: .testIlpPaymentPointer,
                from: .testAccountID,
                withAuthorization: .testBearerToken
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

    func testSendPaymentWithFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        let balanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(XpringKitTestError.mockFailure))
        let paymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(XpringKitTestError.mockFailure))
        let ilpClient = DefaultIlpClient(balanceNetworkClient: balanceNetworkClient, paymentNetworkClient: paymentNetworkClient)

        // WHEN a payment is sent THEN an error is thrown
        XCTAssertThrowsError(try ilpClient.sendPayment(
            .testIlpSendAmount,
            to: .testIlpPaymentPointer,
            from: .testAccountID,
            withAuthorization: .testBearerToken
        ), "Exception not thrown") { error in
            guard
              let _ = error as? XpringKitTestError
                else {
                  XCTFail("Error thrown was not mocked error")
                  return
            }
        }
    }
}
