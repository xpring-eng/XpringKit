import BigInt
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

extension Org_Xrpl_Rpc_V1_IssuedCurrencyAmount {
  static let testIssuedCurrency = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {
    $0.currency = .testCurrency
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r123"
    }
    $0.value = "100"
  }

  static let testInvalidIssuedCurrency = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {
    $0.currency = .testCurrency
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r123"
    }
    $0.value = "xrp" // Invalid because non-numeric
  }

}

/// Tests conversion of protocol buffer to native Swift structs.
final class ProtocolBufferConversionTests: XCTestCase {

  // MARK: - Org_Xrpl_Rpc_V1_Currency

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
      $0.currency = .testCurrency
      $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = "r123"
      }
      $0.value = "12345"
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let issuedCurrency = XRPIssuedCurrency(issuedCurrency: issuedCurrencyProto)

    // THEN the issued currency converted as expected.
    XCTAssertEqual(issuedCurrency?.currency, XRPCurrency(currency: issuedCurrencyProto.currency))
    XCTAssertEqual(issuedCurrency?.issuer, issuedCurrencyProto.issuer.address)
    XCTAssertEqual(issuedCurrency?.value, BigInt(issuedCurrencyProto.value))
  }

  func testConvertIssuedCurrencyWithBadValue() {
    // GIVEN an issued currency protocol buffer with a non numeric value
    let issuedCurrencyProto = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.testInvalidIssuedCurrency

    // WHEN the protocol buffer is converted to a native Swift type.
    let issuedCurrency = XRPIssuedCurrency(issuedCurrency: issuedCurrencyProto)

    // THEN the result is nil
    XCTAssertNil(issuedCurrency)
  }

  // MARK: - Org_Xrpl_Rpc_V1_CurrencyAmount

  func testConvertCurrencyAmountWithDrops() {
    // GIVEN an currency amount protocol buffer with an XRP amount.
    let drops: UInt64 = 10
    let currencyAmountProto = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
      $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
        $0.drops = drops
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmountProto)

    // THEN the result has drops set and no issued amount.
    XCTAssertNil(currencyAmount?.issuedCurrency)
    XCTAssertEqual(currencyAmount?.drops, drops)
  }

  func testConvertCurrencyAmountWithIssuedCurrency() {
    // GIVEN an currency amount protocol buffer with an issued currency amount.
    let currencyAmountProto = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
      $0.issuedCurrencyAmount = .testIssuedCurrency
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmountProto)

    // THEN the result has an issued currency set and no amount.
    XCTAssertEqual(currencyAmount?.issuedCurrency, XRPIssuedCurrency(issuedCurrency: .testIssuedCurrency))
    XCTAssertNil(currencyAmount?.drops)
  }

  func testConvertCurrencyAmountWithBadInputs() {
    // GIVEN an currency amount protocol buffer with no amounts
    let currencyAmountProto = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
      $0.issuedCurrencyAmount = .testInvalidIssuedCurrency
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmountProto)

    // THEN the result is nil
    XCTAssertNil(currencyAmount)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Signer

  func testConvertSignerAllFieldsSet() {
    // GIVEN a Signer protocol buffer with all fields set.
    let account = "r123"
    let signingPublicKey = Data([1, 2, 3])
    let transactionSignature = Data([4, 5, 6])
    let signerProto = Org_Xrpl_Rpc_V1_Signer.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let signer = XRPSigner(signer: signerProto)

    // THEN all fields are present and converted correct.
    XCTAssertEqual(signer.account, account)
    XCTAssertEqual(signer.signingPublicKey, signingPublicKey)
    XCTAssertEqual(signer.transactionSignature, transactionSignature)
  }
}
