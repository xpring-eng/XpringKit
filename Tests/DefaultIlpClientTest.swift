import SwiftGRPC
import XCTest
@testable import XpringKit

final class DefaultIlpClientTest: XCTestCase {

    // MARK: - Balance
    func testGetBalanceWithSuccess() {
        // GIVEN an IlpClient which will successfully return a balance from a mocked network call.
        
        // WHEN the balance is requested
        
        // THEN the balance is correct
    }
    
    func testGetBalanceWithFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        
        // WHEN the balance is requested
        
        // THEN an error is thrown
    }
    

    // MARK: - Payment
    func testSendPaymentWithSuccess() {
        // GIVEN an IlpClient which will successfully return a payment response from a mocked network call.
        
        // WHEN a payment is sent
        
        // THEN the payment response is correct
    }
    
    func testSendPaymentWithFailure() {
        // GIVEN an IlpClient with a network client which will always throw an error.
        
        // WHEN a payment is sent
        
        // THEN an error is thrown
    }
}
