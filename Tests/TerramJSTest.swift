import XCTest
import XpringKit

class TerramJSTest: XCTestCase {
    /// Test that Terram instantiates correctly.
    ///
    /// This test ensures that the javascript is bundled correctly and is well formed.
    func testTerramInit() {
        guard let _ = TerramJS() else {
            XCTFail("Javascript code missing or malformed.")
            return
        }
    }
}
