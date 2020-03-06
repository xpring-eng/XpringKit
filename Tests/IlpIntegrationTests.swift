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
        
        // WHEN the balance of sdk_account1 is requested
        
        // THEN the accountId is sdk_account1
        // AND the assetCode is "XRP"
        // AND the assetScale is 9
        // AND netBalance is less than or equal to 0
        // AND clearingBalance is less than or equal to 0
        // AND prepaidAmount is equal to 0
    }

    func testSendPayment() {
        // GIVEN an IlpClient with a network client hooked up to Hermes
        // AND an ILP account with accountId = sdk_account1
        // AND an ILP account with accoundId = sdk_account2
        
        // WHEN a payment is sent from sdk_account1 to sdk_account2
        
        // THEN the originalAmount is equal to the amount requested
        // AND the amountSent is equal to the amount requested
        // AND the amountDelivered is equal to the amount requested
        // AND the payment was successful
    }

}
