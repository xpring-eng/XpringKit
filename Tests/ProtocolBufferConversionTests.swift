import XCTest
@testable import XpringKit

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
    XCTAssertEqual(currency.code, currencyCode)
    XCTAssertEqual(currency.name, currencyName)
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
