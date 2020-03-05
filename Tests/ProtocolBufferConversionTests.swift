import XCTest
@testable import XpringKit

/// Tests conversion of protocol buffer to native Swift structs.
final class ProtocolBufferConversionTests: XCTestCase {
  func testConvertCurrency() {
    // GIVEN a Currency protocol buffer with a code and a name.
    let currencyCode = Data([1, 2, 3])
    let currencyName = "abc"
    let currencyProto = Org_Xrpl_Rpc_V1_Currency.with {
      $0.code = currencyCode
      $0.name = currencyName
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currency = XRPCurrency(currency: currencyProto)

    // THEN the currency converted as expected.
    XCTAssertEqual(currency.code, currencyCode)
    XCTAssertEqual(currency.name, currencyName)
  }
}
