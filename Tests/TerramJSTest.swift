import XCTest
import XpringKit

class TerramJSTest: XCTestCase {
    private var terram: Terram!

    override func setUp() {
        super.setUp()

        guard let terram = TerramJS() else {
            XCTFail("Could not instantiate Terram :( Check for a missing Javascript resource?")
            return
        }

        self.terram = terram
    }

    func testIsValidAddressValidAddress() {
        XCTAssertTrue(terram.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
    }

    func testIsValidAddressInvalidAlphabet() {
        XCTAssertFalse(terram.isValid(address: "1EAG1MwmzkG6gRZcYqcRMfC17eMt8TDTit"))
    }

    func testIsvValidAddressInvlalidChecksum() {
        XCTAssertFalse(terram.isValid(address: "rU6K7V3Po4sBBBBBaU29sesqs2qTQJWDw1"))
    }

    func testIsValidAddressInvalidCharacters() {
        XCTAssertFalse(terram.isValid(address: "rU6K7V3Po4sBBBBBaU@#$%qs2qTQJWDw1"))
    }

    func testIsValidAddressTooLong() {
        XCTAssertFalse(terram.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
    }

    func testIsValidAddressTooShort() {
        XCTAssertFalse(terram.isValid(address: "rU6K7V3Po4s2qTQJWDw1"))
    }
}
