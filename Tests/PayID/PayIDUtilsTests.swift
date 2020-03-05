import XCTest
import XpringKit

class PayIDUtilsTest: XCTestCase {
  func testParsePaymentPointerHostAndPath() {
    // GIVEN a payment pointer with a host and a path.
    let rawPaymentPointer = "$example.com/foo"

    // WHEN it is parsed to a PaymentPointer object
    let paymentPointer = PayIDUtils.parse(paymentPointer: rawPaymentPointer)

    // THEN the host and path are set correctly.
    XCTAssertEqual(paymentPointer?.host, "example.com")
    XCTAssertEqual(paymentPointer?.host, "/foo")
  }

  func testParsePaymentPointerWithWellKnownPath() {
    // GIVEN a payment pointer with a well known path.
    let rawPaymentPointer = "$example.com"

    // WHEN it is parsed to a PaymentPointer object
    let paymentPointer = PayIDUtils.parse(paymentPointer: rawPaymentPointer)

    // THEN the host and path are set correctly.
    XCTAssertEqual(paymentPointer?.host, "example.com")
    XCTAssertEqual(paymentPointer?.path, PaymentPointer.paymentPointerWellKnownPath)
  }

  func testParsePaymentPointerWithWellKnownPathAndTrailingSlash() {
    // GIVEN a payment pointer with a well known path and a trailing slash.
    let rawPaymentPointer = "$example.com"

    // WHEN it is parsed to a PaymentPointer object
    let paymentPointer = PayIDUtils.parse(paymentPointer: rawPaymentPointer)

    // THEN the host and path are set correctly.
    XCTAssertEqual(paymentPointer?.host, "example.com")
    XCTAssertEqual(paymentPointer?.path, PaymentPointer.paymentPointerWellKnownPath)
  }

  func testParsePaymentPointerIncorrectPrefix() {
    // GIVEN a payment pointer without a '$' prefix
    let rawPaymentPointer = 'example.com/'

    // WHEN it is parsed to a PaymentPointer object THEN the result is undefined
    XCTAssertNil(PayIDUtils.parse(paymentPointer: rawPaymentPointer))
  }

  func testParsePaymentPointerEmptyHost() {
    // GIVEN a payment pointer without a host.
    let rawPaymentPointer = '$'

    // WHEN it is parsed to a PaymentPointer object THEN the result is undefined
    XCTAssertNil(PayIDUtils.parse(paymentPointer: rawPaymentPointer))
  }

  func testParsePaymentPointerNonAscii() {
    // GIVEN a payment pointer with non-ascii characters.
    let rawPaymentPointer = '$ZA̡͊͠͝LGΌ IS̯͈͕̹̘̱ͮ TO͇̹̺ͅƝ̴ȳ̳ TH̘Ë͖́̉ ͠P̯͍̭O̚N̐Y̡'

    // WHEN it is parsed to a PaymentPointer object THEN the result is undefined
    XCTAssertNil(PayIDUtils.parse(paymentPointer: rawPaymentPointer))
  }
}
