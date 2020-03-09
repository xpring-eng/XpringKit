import XCTest
import XpringKit

extension String {
    public static let grpcURL = "hermes-grpc.ilpv4.dev"
}

class IlpIntegrationTests: XCTestCase {

    private let ilpClient = IlpClient(grpcURL: .grpcURL)

    func testGetBalance() {
        // GIVEN an IlpClient with a network client hooked up to Hermes
        // AND an ILP account with accountId = sdk_account1
        do {
            // WHEN the balance of sdk_account1 is requested
            let balance = try ilpClient.getBalance(for: .testAccountID,
                                                   withAuthorization: .testBearerToken)

            // THEN the accountId is sdk_account1
            // AND the assetCode is "XRP"
            // AND the assetScale is 9
            // AND netBalance is less than or equal to 0
            // AND clearingBalance is less than or equal to 0
            // AND prepaidAmount is equal to 0
            XCTAssertEqual(balance.accountID, .testAccountID)
            XCTAssertEqual(balance.assetCode, .testAssetCode)
            XCTAssertEqual(balance.assetScale, .testAssetScale)
            XCTAssertEqual(balance.prepaidAmount, 0)
            XCTAssert(balance.netBalance <= 0)
            XCTAssert(balance.clearingBalance <= 0)
        } catch {
            XCTFail("Failed retrieving balance with error: \(error)")
        }
    }

    func testSendPayment() {
        // GIVEN an IlpClient with a network client hooked up to Hermes
        // AND an ILP account with accountId = sdk_account1
        // AND an ILP account with accoundId = sdk_account2
        do {
            // WHEN a payment is sent from sdk_account1 to sdk_account2
            let payment = try ilpClient.sendPayment(.testIlpSendAmount,
                                                    to: .testIlpPaymentPointer,
                                                    from: .testAccountID,
                                                    withAuthorization: .testBearerToken)

            // THEN the originalAmount is equal to the amount requested
            // AND the amountSent is equal to the amount requested
            // AND the amountDelivered is equal to the amount requested
            // AND the payment was successful
            XCTAssertEqual(payment.originalAmount, .testIlpSendAmount)
            XCTAssertEqual(payment.amountSent, .testIlpSendAmount)
            XCTAssertEqual(payment.amountDelivered, .testIlpSendAmount)
            XCTAssertEqual(payment.successfulPayment, true)
        } catch {
            XCTFail("Failed to send payment with error: \(error)")
        }
    }

}
