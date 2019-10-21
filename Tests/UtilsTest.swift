import XCTest
import XpringKit

class UtilsTest: XCTestCase {
	func testIsValidAddressValidClassicAddress() {
		XCTAssertTrue(Utils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
	}

    func testIsValidAddressValidXAddress() {
        XCTAssertTrue(Utils.isValid(address: "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHi"))
    }

	func testIsValidAddressInvalidAlphabet() {
		XCTAssertFalse(Utils.isValid(address: "1EAG1MwmzkG6gRZcYqcRMfC17eMt8TDTit"))
	}

	func testIsvValidAddressInvalidChecksumClassicAddress() {
		XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4sBBBBBaU29sesqs2qTQJWDw1"))
	}

    func testIsvValidAddressInvalidChecksumXAddress() {
        XCTAssertFalse(Utils.isValid(address: "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHI"))
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
