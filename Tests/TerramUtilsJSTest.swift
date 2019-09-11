import XCTest
import XpringKit

class TerramUtilsJSTest: XCTestCase {
    private var terramUtils: TerramUtils!

    override func setUp() {
        super.setUp()

        guard let terramUtils = TerramUtilsJS() else {
            XCTFail("Could not instantiate Terram :( Check for a missing Javascript resource?")
            return
        }

        self.terramUtils = terramUtils
    }

    func testIsValidAddressValidAddress() {
        XCTAssertTrue(terramUtils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
    }

    func testIsValidAddressInvalidAlphabet() {
        XCTAssertFalse(terramUtils.isValid(address: "1EAG1MwmzkG6gRZcYqcRMfC17eMt8TDTit"))
    }

    func testIsvValidAddressInvlalidChecksum() {
        XCTAssertFalse(terramUtils.isValid(address: "rU6K7V3Po4sBBBBBaU29sesqs2qTQJWDw1"))
    }

    func testIsValidAddressInvalidCharacters() {
        XCTAssertFalse(terramUtils.isValid(address: "rU6K7V3Po4sBBBBBaU@#$%qs2qTQJWDw1"))
    }

    func testIsValidAddressTooLong() {
        XCTAssertFalse(terramUtils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
    }

    func testIsValidAddressTooShort() {
        XCTAssertFalse(terramUtils.isValid(address: "rU6K7V3Po4s2qTQJWDw1"))
    }
}
