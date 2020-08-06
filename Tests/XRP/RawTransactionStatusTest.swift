import XCTest
import XpringKit

class RawTransactionStatusTest: XCTestCase {
  // MARK: - rippled Protocol Buffers

  func testNonPaymentIsFullPayment() {
    // GIVEN a getTransactionResponse which is not a payment.
    let getTxResponse = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
        $0.transactionData = .none
      }
    }

    // WHEN the response is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(getTransactionResponse: getTxResponse)

    // THEN the raw transaction status reports it is not a full payment.
    XCTAssertFalse(rawTransactionStatus.isFullPayment)
  }

  func testPartialPaymentIsFullPayment() {
    // GIVEN a getTransactionResponse which is a payment with the partial payment flags set.
    let getTxResponse = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
        $0.payment = Org_Xrpl_Rpc_V1_Payment()
        $0.flags = Org_Xrpl_Rpc_V1_Flags.with {
          $0.value = PaymentFlag.tfPartialPayment.rawValue
        }
      }
    }

    // WHEN the response is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(getTransactionResponse: getTxResponse)

    // THEN the raw transaction status reports it is not a full payment.
    XCTAssertFalse(rawTransactionStatus.isFullPayment)
  }

  func testPaymentIsFullPayment() {
    // GIVEN a getTransactionResponse which is a payment.
    let getTxResponse = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
        $0.payment = Org_Xrpl_Rpc_V1_Payment()
      }
    }

    // WHEN the response is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(getTransactionResponse: getTxResponse)

    // THEN the raw transaction status reports it is a full payment.
    XCTAssertTrue(rawTransactionStatus.isFullPayment)
  }
}
