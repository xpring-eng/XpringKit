import XCTest
import XpringKit

extension String {
    public static let grpcURL = "hermes-grpc.ilpv4.dev"

    public static let testAccountID = "sdk_account1"

    public static let testAccountIDAuthToken = "password"

}

class IlpIntegrationTests: XCTestCase {

    private let ilpClient = IlpClient(grpcURL: .grpcURL)

    func testGetBalance() {
        // GIVEN an IlpClient with a network client hooked up to Hermes
        // AND an ILP account with accountId = sdk_account1
        do {
            // WHEN the balance of sdk_account1 is requested
            let balance = try ilpClient.getBalance(for: .testAccountID,
                                                   withAuthorization: .testAccountIDAuthToken)

            // THEN the accountId is sdk_account1
            // AND the assetCode is "XRP"
            // AND the assetScale is 9
            // AND netBalance is less than or equal to 0
            // AND clearingBalance is less than or equal to 0
            // AND prepaidAmount is equal to 0
            XCTAssertEqual(balance.accountID, .testAccountID)
            XCTAssertEqual(balance.assetCode, "XRP")
            XCTAssertEqual(balance.assetScale, 9)
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
            let payment = try ilpClient.sendPayment(10,
                                                    to: "$money.ilpv4.dev/sdk_account2",
                                                    from: .testAccountID,
                                                    withAuthorization: .testAccountIDAuthToken)

            // THEN the originalAmount is equal to the amount requested
            // AND the amountSent is equal to the amount requested
            // AND the amountDelivered is equal to the amount requested
            // AND the payment was successful
            XCTAssertEqual(payment.originalAmount, 10)
            XCTAssertEqual(payment.amountSent, 10)
            XCTAssertEqual(payment.amountDelivered, 10)
            XCTAssertEqual(payment.successfulPayment, true)
        } catch {
            XCTFail("Failed to send payment with error: \(error)")
        }
    }

}
