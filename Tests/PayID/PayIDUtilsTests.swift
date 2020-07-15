import XCTest
import XpringKit

class PayIDUtilsTest: XCTestCase {
  func testParseValidPayID() {
    // GIVEN a Pay ID with a host and a path.
    let host = "xpring.money"
    let path = "georgewashington"
    let rawPayID = "\(path)$\(host)"

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the host and path are set correctly.
    XCTAssertEqual(payIDComponents?.host, host)
    XCTAssertEqual(payIDComponents?.path, "/\(path)")
  }

  func testParsePayIDMultipleDollarSigns() {
    // GIVEN a Pay ID with more than one '$'.
    let host = "xpring.money"
    let path = "george$$$washington$$$" // Extra '$'s
    let rawPayID = "\(path)$\(host)"

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the host and path are set correctly.
    XCTAssertEqual(payIDComponents?.host, host)
    XCTAssertEqual(payIDComponents?.path, "/\(path)")
  }

  func testParsePayIDNoDollarSigns() {
    // GIVEN a Pay ID with no '$'.
    let host = "xpring.money"
    let path = "georgewashington"
    let rawPayID = "\(path)\(host)"  // Assembled without $

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the Pay ID failed to parse.
    XCTAssertNil(payIDComponents)
  }

  func testParsePayIDHostEndsWithDollarSign() {
    // GIVEN a Pay ID in which the host ends with a $.
    let host = "xpring.money$"
    let path = "georgewashington"
    let rawPayID = "\(path)\(host)"

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the Pay ID failed to parse.
    XCTAssertNil(payIDComponents)
  }

  func testParsePayIDEmptyHost() {
    // GIVEN a Pay ID with an empty host.
    let host = ""
    let path = "georgewashington"
    let rawPayID = "\(path)$\(host)"

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the Pay ID failed to parse.
    XCTAssertNil(payIDComponents)
  }

  func testParsePayIDEmptyPath() {
    // GIVEN a Pay ID with an empty user.
    let host = "xpring.money"
    let path = ""
    let rawPayID = "\(path)$\(host)"

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the Pay ID failed to parse.
    XCTAssertNil(payIDComponents)
  }

  func testParsePayIDNonASCII() {
    // GIVEN a Pay ID with non-ascii characters.
    let rawPayID = "ZA̡͊͠͝LGΌIS̯͈͕̹̘̱ͮ$TO͇̹̺ͅƝ̴ȳ̳TH̘Ë͖́̉ ͠P̯͍̭O̚N̐Y̡"

    // WHEN it is parsed to components.
    let payIDComponents = PayIDUtils.parse(payID: rawPayID)

    // THEN the Pay ID failed to parse.
    XCTAssertNil(payIDComponents)
  }
}
