import XCTest
@testable import XpringKit

// TODO(keefertaylor): Refactor these to separate files.
extension Org_Xrpl_Rpc_V1_Currency {
  static let testCurrency = Org_Xrpl_Rpc_V1_Currency.with {
    $0.code = Data([1, 2, 3])
    $0.name = "currencyName"
  }
}

/// Tests conversion of protocol buffer to native Swift structs.
final class ProtocolBufferConversionTests: XCTestCase {

  // MARK: - Org_Xrpl_Rpc_V1_Currency

  func testConvertCurrency() {
    // GIVEN a Currency protocol buffer with a code and a name.
    let currencyProto = Org_Xrpl_Rpc_V1_Currency.testCurrency

    // WHEN the protocol buffer is converted to a native Swift type.
    let currency = XRPCurrency(currency: currencyProto)

    // THEN the currency converted as expected.
    XCTAssertEqual(currency.code, currencyProto.code)
    XCTAssertEqual(currency.name, currencyProto.name)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Transaction.PathElement

  func testConvertPathElementAllFieldsSet() {
    // GIVEN a PathElement protocol buffer with all fields set.
    let pathElementProto = Org_Xrpl_Rpc_V1_Payment.PathElement.with {
      $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = "r123"
      }
      $0.currency = .testCurrency
      $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = "r456"
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let pathElement = XRPPathElement(pathElement: pathElementProto)

    // THEN the currency converted as expected.
    XCTAssertEqual(pathElement.account, pathElementProto.account.address)
    XCTAssertEqual(pathElement.currency, XRPCurrency(currency: .testCurrency))
    XCTAssertEqual(pathElement.issuer, pathElementProto.issuer.address)
  }

  func testConvertPathElementNoFieldsSet() {
    // GIVEN a PathElement protocol buffer with no fields set.
    let pathElementProto = Org_Xrpl_Rpc_V1_Payment.PathElement()

    // WHEN the protocol buffer is converted to a native Swift type.
    let pathElement = XRPPathElement(pathElement: pathElementProto)

    // THEN the currency converted as expected.
    XCTAssertNil(pathElement.account)
    XCTAssertNil(pathElement.currency)
    XCTAssertNil(pathElement.issuer)
  }
}
