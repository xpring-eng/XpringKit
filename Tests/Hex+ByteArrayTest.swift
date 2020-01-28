import XCTest
import XpringKit

final class HexByteArrayTest: XCTestCase {
  // Hex and expected bytes.
  private final let hex =  "00" + "01" + "0A" + "BB"
  private final let expectedBytes: [UInt8] = [0, 1, 10, 187]

  func testBackForth() {
    let s = "DEADBEEF"
    let b = try! s.toBytes()
    print(b)

    XCTAssertEqual(s, b.toHex())
  }

  func testToByteArrayUpperCaseHex() {
    // GIVEN an upper case hex string.
    let upperCasedHex = hex.uppercased()

    // WHEN the string is converted to bytes.
    guard let bytes = try? upperCasedHex.toBytes() else {
      XCTFail("Failed to convert bytes")
      return
    }

    // THEN the bytes are as expected
    XCTAssertEqual(bytes, expectedBytes)
  }

  func testToByteArrayLowerCaseHex() {
    // GIVEN an lower case hex string.
    let upperCasedHex = hex.lowercased()

    // WHEN the string is converted to bytes.
    guard let bytes = try? upperCasedHex.toBytes() else {
      XCTFail("Failed to convert bytes")
      return
    }

    // THEN the bytes are as expected
    XCTAssertEqual(bytes, expectedBytes)
  }

  func testToByteArrayInvalidHex() {
    // GIVEN an invalid hex string.
    let invalidHex = "xrp"

    // WHEN the string is converted to bytes THEN an error is thrown.
    XCTAssertThrowsError(try invalidHex.toBytes())
  }

  func testToByteArrayInvalidLength() {
    // GIVEN a hex string of invalid length.
    let invalidHex = "00a"

    // WHEN the string is converted to bytes THEN an error is thrown.
    XCTAssertThrowsError(try invalidHex.toBytes())
  }
}
