import XCTest
import XpringKit

class UtilsTest: XCTestCase {
	func testIsValidAddressValidAddress() {
		XCTAssertTrue(Utils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
	}

	func testIsValidAddressInvalidAlphabet() {
		XCTAssertFalse(Utils.isValid(address: "1EAG1MwmzkG6gRZcYqcRMfC17eMt8TDTit"))
	}

	func testIsvValidAddressInvlalidChecksum() {
		XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4sBBBBBaU29sesqs2qTQJWDw1"))
	}

	func testIsValidAddressInvalidCharacters() {
		XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4sBBBBBaU@#$%qs2qTQJWDw1"))
	}

	func testIsValidAddressTooLong() {
		XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
	}

	func testIsValidAddressTooShort() {
		XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4s2qTQJWDw1"))
	}
}
