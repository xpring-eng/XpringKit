import Foundation
import BigInt
import XCTest
@testable import XpringKit

final class XpringClientTest: XCTestCase {
	static let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
	static let destinationAddress = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
	static let sendAmount = BigUInt(stringLiteral: "20")

	// MARK: - Balance
	func testGetBalanceWithSuccess() {
		print("hello world")
	}
}
