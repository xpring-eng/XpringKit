import XCTest
@testable import XpringKit

final class DefaultXpringClientTest: XCTestCase {

  // MARK: - Balance

  func testGetBalanceWithSuccess() {
    // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
    let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

    // WHEN the balance is requested.
    guard let balance = try? xpringClient.getBalance(for: .destinationAddress) else {
      XCTFail("Exception should not be thrown when trying to get a balance")
      return
    }

    // THEN the balance is correct.
    XCTAssertEqual(balance, .balance)
  }

  func testGetBalanceWithClassicAddress() {
    // GIVEN a classic address.
    guard let classicAddressComponents = Utils.decode(xAddress: .destinationAddress) else {
      XCTFail("Failed to decode X-Address.")
      return
    }
    let xpringClient = DefaultXpringClient(networkClient: FakeNetworkClient.successfulFakeNetworkClient)

    // WHEN the balance is requested THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.getBalance(for: classicAddressComponents.classicAddress))
  }

  func testGetBalanceWithFailure() {
    // GIVEN a Xpring client which will throw an error when a balance is requested.
    let networkClient = FakeNetworkClient(
      accountInfoResult: .failure(XpringKitTestError.mockFailure),
      feeResult: .success(.testGetFeeResponse),
      submitTransactionResult: .success(.testSubmitTransactionResponse),
      transactionStatusResult: .success(.testGetTxResponse)
    )
    let xpringClient = DefaultXpringClient(networkClient: networkClient)

    // WHEN the balance is requested THEN the error is thrown.
    XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
  }

  // MARK: - Transaction Status

  func testGetTransactionStatusWithUnvalidatedTransactionAndFailureCode() {
    // GIVEN a XpringClient which returns an unvalidated transaction and a failed transaction status code.
    let transactionStatusResponse = makeGetTxResonse(validated: false, resultCode: .transactionStatusCodeFailure)
    let networkClient = FakeNetworkClient(
      accountInfoResult: .success(.testGetAccountInfoResponse),
      feeResult: .success(.testGetFeeResponse),
      submitTransactionResult: .success(.testSubmitTransactionResponse),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = DefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is pending.
    XCTAssertEqual(transactionStatus, .pending)
  }

  func testGetTransactionStatusWithUnvalidatedTransactionAndSuccessCode() {
    // GIVEN a XpringClient which returns an unvalidated transaction and a succeeded transaction status code.
    let transactionStatusResponse = makeGetTxResonse(validated: false, resultCode: .transactionStatusCodeSuccess)
    let networkClient = FakeNetworkClient(
      accountInfoResult: .success(.testGetAccountInfoResponse),
      feeResult: .success(.testGetFeeResponse),
      submitTransactionResult: .success(.testSubmitTransactionResponse),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = DefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is pending.
    XCTAssertEqual(transactionStatus, .pending)
  }

  func testGetTransactionStatusWithValidatedTransactionAndFailureCode() {
    // GIVEN a XpringClient which returns a validated transaction and a failed transaction status code.
    let transactionStatusResponse = makeGetTxResonse(validated: true, resultCode: .transactionStatusCodeFailure)
    let networkClient = FakeNetworkClient(
      accountInfoResult: .success(.testGetAccountInfoResponse),
      feeResult: .success(.testGetFeeResponse),
      submitTransactionResult: .success(.testSubmitTransactionResponse),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = DefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is failed.
    XCTAssertEqual(transactionStatus, .failed)
  }

  func testGetTransactionStatusWithValidatedTransactionAndSuccessCode() {
    // GIVEN a XpringClient which returns a validated transaction and a succeeded transaction status code.
    let transactionStatusResponse = makeGetTxResonse(validated: true, resultCode: .transactionStatusCodeSuccess)
    let networkClient = FakeNetworkClient(
      accountInfoResult: .success(.testGetAccountInfoResponse),
      feeResult: .success(.testGetFeeResponse),
      submitTransactionResult: .success(.testSubmitTransactionResponse),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = DefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is succeeded.
    XCTAssertEqual(transactionStatus, .succeeded)
  }

  func testGetTransactionStatusWithServerFailure() {
    // GIVEN a XpringClient which fails to return a transaction status.
    let networkClient = FakeNetworkClient(
      accountInfoResult: .success(.testGetAccountInfoResponse),
      feeResult: .success(.testGetFeeResponse),
      submitTransactionResult: .success(.testSubmitTransactionResponse),
      transactionStatusResult: .failure(XpringKitTestError.mockFailure)
    )
    let xpringClient = DefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.getTransactionStatus(for: .testTransactionHash))
  }

  // MARK: - Helpers

  private func makeGetTxResonse(validated: Bool, resultCode: String) -> Rpc_V1_GetTxResponse {
    return Rpc_V1_GetTxResponse.with {
      $0.validated = validated
      $0.meta = Rpc_V1_Meta.with {
        $0.transactionResult = Rpc_V1_TransactionResult.with {
          $0.result = resultCode
        }
      }
    }
  }
}
