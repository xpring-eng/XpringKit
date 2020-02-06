import XCTest
@testable import XpringKit

final class LegacyDefaultXpringClientTest: XCTestCase {
  // MARK: - Balance

  func testGetBalanceWithSuccess() {
    // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
    let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

    // WHEN the balance is requested.
    guard let balance = try? xpringClient.getBalance(for: .testAddress) else {
      XCTFail("Exception should not be thrown when trying to get a balance")
      return
    }

    // THEN the balance is correct.
    XCTAssertEqual(balance, .testBalance)
  }

  func testGetBalanceWithClassicAddress() {
    // GIVEN a classic address.
    guard let classicAddressComponents = Utils.decode(xAddress: .testAddress) else {
      XCTFail("Failed to decode X-Address.")
      return
    }
    let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

    // WHEN the balance is requested THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.getBalance(for: classicAddressComponents.classicAddress))
  }

  func testGetBalanceWithFailure() {
    // GIVEN a Xpring client which will throw an error when a balance is requested.
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .failure(XpringKitTestError.mockFailure),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(.testTransactionStatus)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN the balance is requested THEN the error is thrown.
    XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
  }

  // MARK: - Send

  func testSendWithSuccess() {
    // GIVEN a Xpring client which will successfully return a balance from a mocked network call.
    let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

    // WHEN XRP is sent.
    guard
      let transactionHash = try? xpringClient.send(
        .testSendAmount,
        to: .testAddress,
        from: .testWallet)
      else {
        XCTFail("Exception should not be thrown when trying to send XRP")
        return
    }

    // THEN the engine result code is as expected.
    XCTAssertEqual(transactionHash, Utils.toTransactionHash(transactionBlobHex: .testTransactionBlobHex))
  }

  func testSendWithClassicAddress() {
    // GIVEN a classic address.
    guard let classicAddressComponents = Utils.decode(xAddress: .testAddress) else {
      XCTFail("Failed to decode X-Address.")
      return
    }
    let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)

    // WHEN XRP is sent to a classic address THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      .testSendAmount,
      to: classicAddressComponents.classicAddress,
      from: .testWallet
      ))
  }

  func testSendWithInvalidAddress() {
    // GIVEN a Xpring client and an invalid destination address.
    let xpringClient = LegacyDefaultXpringClient(networkClient: LegacyFakeNetworkClient.successfulFakeNetworkClient)
    let destinationAddress = "xrp"

    // WHEN XRP is sent to an invalid address THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      .testSendAmount,
      to: destinationAddress,
      from: .testWallet
      ))
  }

  func testSendWithAccountInfoFailure() {
    // GIVEN a Xpring client which will fail to return account info.
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .failure(XpringKitTestError.mockFailure),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(.testTransactionStatus)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN a send is attempted then an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      .testSendAmount,
      to: .testAddress,
      from: .testWallet
      ))
  }

  func testSendWithFeeFailure() {
    // GIVEN a Xpring client which will fail to return a fee.
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .failure(XpringKitTestError.mockFailure),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(.testTransactionStatus)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN a send is attempted then an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      .testSendAmount,
      to: .testAddress,
      from: .testWallet
      ))
  }

  func testSendWithLatestLedgerSequenceFailure() {
    // GIVEN a Xpring client which will fail to return the latest validated ledger sequence.
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .failure(XpringKitTestError.mockFailure),
      transactionStatusResult: .success(.testTransactionStatus)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN a send is attempted then an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(.testSendAmount, to: .testAddress, from: .testWallet))
  }

  func testSendWithSubmitFailure() {
    // GIVEN a Xpring client which will fail to submit a transaction.
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .failure(XpringKitTestError.mockFailure),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(.testTransactionStatus)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN a send is attempted then an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      .testSendAmount,
      to: .testAddress,
      from: .testWallet
      ))
  }

  // MARK: - Transaction Status

  func testGetTransactionStatusWithUnvalidatedTransactionAndFailureCode() {
    // GIVEN a XpringClient which returns an unvalidated transaction and a failed transaction status code.
    let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
      $0.validated = false
      $0.transactionStatusCode = .testTransactionStatusCodeFailure
    }
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is pending.
    XCTAssertEqual(transactionStatus, .pending)
  }

  func testGetTransactionStatusWithUnvalidatedTransactionAndSuccessCode() {
    // GIVEN a XpringClient which returns an unvalidated transaction and a succeeded transaction status code.
    let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
      $0.validated = false
      $0.transactionStatusCode = .testTransactionStatusCodeSuccess
    }
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is pending.
    XCTAssertEqual(transactionStatus, .pending)
  }

  func testGetTransactionStatusWithValidatedTransactionAndFailureCode() {
    // GIVEN a XpringClient which returns a validated transaction and a failed transaction status code.
    let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
      $0.validated = true
      $0.transactionStatusCode = .testTransactionStatusCodeFailure
    }
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is failed.
    XCTAssertEqual(transactionStatus, .failed)
  }

  func testGetTransactionStatusWithValidatedTransactionAndSuccessCode() {
    // GIVEN a XpringClient which returns a validated transaction and a succeeded transaction status code.
    let transactionStatusResponse = Io_Xpring_TransactionStatus.with {
      $0.validated = true
      $0.transactionStatusCode = .testTransactionStatusCodeSuccess
    }
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .success(transactionStatusResponse)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved.
    let transactionStatus = try? xpringClient.getTransactionStatus(for: .testTransactionHash)

    // THEN the transaction status is succeeded.
    XCTAssertEqual(transactionStatus, .succeeded)
  }

  func testGetTransactionStatusWithServerFailure() {
    // GIVEN a XpringClient which fails to return a transaction status.
    let networkClient = LegacyFakeNetworkClient(
      accountInfoResult: .success(.testAccountInfo),
      feeResult: .success(.testFee),
      submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
      transactionStatusResult: .failure(XpringKitTestError.mockFailure)
    )
    let xpringClient = LegacyDefaultXpringClient(networkClient: networkClient)

    // WHEN the transaction status is retrieved THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.getTransactionStatus(for: .testTransactionHash))
  }
}
