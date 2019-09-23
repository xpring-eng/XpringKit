import XCTest
// TODO: Remove testable
@testable import XpringKit

final class XpringClientTest: XCTestCase {
	func testIntegrationTest() {
		let grpcURL = "127.0.0.1:3002" //"grpc.xpring.tech:80"
		let networkClient = Io_Xpring_XRPLedgerServiceClient(address: grpcURL, secure: false)
		let xpringClient = XpringClient(networkClient: networkClient)

		let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
		XCTAssertEqual(wallet.address, "rByLcEZ7iwTBAK8FfjtpFuT7fCzt4kF4r2")

		let balance = try! xpringClient.getBalance(for: wallet.address)
		print(balance)

		let amount = Io_Xpring_XRPAmount.with { $0.drops = "1" }
		let result = try! xpringClient.send(amount, to: "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn", from: wallet)
		print(result)

		let balance2 = try! xpringClient.getBalance(for: wallet.address)
		print(balance2)
	}

	func testGetBalanceWithSuccess() {
		// GIVEN a Xpring client which will successfully return a balance from a mocked network call.
		let balance = "1000"
		let accountInfo = Io_Xpring_AccountInfo.with {
			$0.balance = Io_Xpring_XRPAmount.with {
				$0.drops = balance
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
