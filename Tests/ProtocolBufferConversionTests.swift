import XCTest
@testable import XpringKit

// TODO(keefertaylor): Refactor these to separate files.
extension Org_Xrpl_Rpc_V1_Currency {
  static let testCurrency = Org_Xrpl_Rpc_V1_Currency.with {
    $0.code = Data([1, 2, 3])
    $0.name = "currencyName"
  }
}

extension Org_Xrpl_Rpc_V1_Payment.PathElement {
  static let testPathElement = Org_Xrpl_Rpc_V1_Payment.PathElement.with {
    $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r123"
    }
    $0.currency = .testCurrency
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r456"
    }
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
    let pathElementProto = Org_Xrpl_Rpc_V1_Payment.PathElement.testPathElement

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

  // MARK: - Org_Xrpl_Rpc_V1_Transaction.Path

  func testConvertPathsWithNoPaths() {
    // GIVEN a set of paths with zero paths.
    let pathProto = Org_Xrpl_Rpc_V1_Payment.Path()

    // WHEN the protocol buffer is converted to a native Swift type.
    let path = XRPPath(path: pathProto)

    // THEN there are zero paths in the output.
    XCTAssertEqual(path.pathElements.count, 0)
  }

  func testConvertPathsWithOnePath() {
    // GIVEN a set of paths with one path.
    let pathProto = Org_Xrpl_Rpc_V1_Payment.Path.with {
      $0.elements = [ .testPathElement ]
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let path = XRPPath(path: pathProto)

    // THEN there is one path in the output.
    XCTAssertEqual(path.pathElements.count, 1)
  }

  func testConvertPathsWithManyPaths() {
    // GIVEN a set of paths with one path.
    let pathProto = Org_Xrpl_Rpc_V1_Payment.Path.with {
      $0.elements = [ .testPathElement, .testPathElement, .testPathElement ]
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let path = XRPPath(path: pathProto)

    // THEN there are multiple paths in the output.
    XCTAssertEqual(path.pathElements.count, 3)
  }

  // MARK: - Org_Xrpl_Rpc_V1_IssuedCurrencyAmount

  func testConvertIssuedCurrency() {
    // GIVEN an issued currency protocol buffer
    let issuedCurrencyProto = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {

    }
  }
}
