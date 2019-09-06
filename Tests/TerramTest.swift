import XCTest
import XpringKit

class TerramTest: XCTestCase {
    func testTerram() {
        guard let terram = Terram() else {
            XCTFail()
            return
        }

        XCTAssertNotNil(terram.xpring())
        XCTAssertEqual(terram.xpring(), "xpring")
    }
}
