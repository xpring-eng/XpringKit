import XCTest
import XpringKit

final class XpringClientTest: XCTestCase {
    func testGetBalanceWithSuccess() {
        // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
        let balance = "1000"
        let accountInfo = AccountInfo.with {
            $0.accountData = AccountData.with {
                $0.balance = balance
            }
        }
        let networkClient = FakeNetworkClient(accountInfoResult: .success(accountInfo))
        let xpringClient = XpringClient(networkClient: networkClient)

        // WHEN the balance is requested.
        guard let xrpAmount = try? xpringClient.getBalance(for: .testAddress) else {
            XCTFail("Exception should not be thrown when trying to get a balance")
            return
        }

        // THEN the balance is correct.
        XCTAssertEqual(xrpAmount.drops, balance)
    }

    func testGetBalanceWithFailure() {
        // GIVEN a Xpring client which will throw an error when a balance is requested.
        let networkClient = FakeNetworkClient(accountInfoResult: .failure(XpringKitTestError.mockFailure))
        let xpringClient = XpringClient(networkClient: networkClient)

        // WHEN the balance is requested THEN the error is thrown.
        XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
    }
}
