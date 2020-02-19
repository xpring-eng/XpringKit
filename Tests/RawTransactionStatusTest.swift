import XCTest
import XpringKit

class RawTransactionStatusTest: XCTestCase {

  // MARK: - Legacy Protocol Buffers

  func testLegacyProtoIsBucketable () {
    // GIVEN a legacy transaction status protocol buffer.
    let transactionStatus = Io_Xpring_TransactionStatus.testTransactionStatus

    // WHEN the raw transaction status is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(transactionStatus: transactionStatus)

    // THEN the raw transaction status reports it is bucketable.
    XCTAssertTrue(rawTransactionStatus.isBucketable)
  }

  // MARK: - rippled Protocol Buffers

  func testNonPaymentIsNotBucketable() {
    // GIVEN a getTxResponse which is not a payment.
    let getTxResponse = Rpc_V1_GetTxResponse.with {
      $0.transaction = Rpc_V1_Transaction.with {
        $0.transactionData = .none
      }
    }

    // WHEN the raw transaction status is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(getTxResponse: getTxResponse)

    // THEN the raw transaction status reports it is not bucketable.
    XCTAssertFalse(rawTransactionStatus.isBucketable)
  }

  func testPartialPaymentIsNotBucketable() {
    // GIVEN a getTxResponse which is a payment with the partial payment flags set.
    let getTxResponse = Rpc_V1_GetTxResponse.with {
      $0.transaction = Rpc_V1_Transaction.with {
        $0.payment = Rpc_V1_Payment()
        $0.flags = RippledFlags.tfPartialPayment.rawValue
      }
    }

    // WHEN the raw transaction status is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(getTxResponse: getTxResponse)

    // THEN the raw transaction status reports it is not bucketable.
    XCTAssertFalse(rawTransactionStatus.isBucketable)
  }

  func testPaymentIsBucketable() {
    // GIVEN a getTxResponse which is a payment.
    let getTxResponse = Rpc_V1_GetTxResponse.with {
      $0.transaction = Rpc_V1_Transaction.with {
        $0.payment = Rpc_V1_Payment()
      }
    }

    // WHEN the raw transaction status is wrapped into a RawTransactionStatus object.
    let rawTransactionStatus = RawTransactionStatus(getTxResponse: getTxResponse)

    // THEN the raw transaction status reports it is bucketable.
    XCTAssertTrue(rawTransactionStatus.isBucketable)
  }
}
