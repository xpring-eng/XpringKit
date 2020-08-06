import Foundation
import XCTest
@testable import XpringKit

final class XpringClientTest: XCTestCase {
  /// Default values for FakeXRPClient. These values must be provided but are not varied in testing.
  private let fakeBalanceValue: UInt64 = 10
  private let fakeTransactionStatusValue = TransactionStatus.succeeded
  private let fakeLastLedgerSequenceValue: UInt32 = 10
  private let fakeRawTransactionStatusValue = RawTransactionStatus(
    getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse()
  )
  private let fakePaymentHistoryValue: [XRPTransaction] = []
  private let fakeAccountExistsValue = true
  private let fakeGetPaymentValue = XRPTransaction(
    getTransactionResponse: .testGetTransactionResponse,
    xrplNetwork: XRPLNetwork.test
  )
  private let fakeEnableDepositAuthValue = TransactionResult(
    hash: "deadbeefdeadbeefdeadbeef",
    status: TransactionStatus.succeeded,
    validated: true
  )

  ///An amount to send.
  private let amount: UInt64 = 10

  /// A Pay ID to resolve.
  private let payID = "$xpring.money/georgewashington"

  /// A wallet
  private let wallet = FakeWallet(signature: [0, 1, 2, 3])

  /// Errors  to throw.
  private let payIDError = PayIDError.unknown(error: "Test PayID error")
  private let xrpError = XRPLedgerError.unknown("Test XRP error")

  func testSendSuccessAsync() throws {
    // GIVEN a XpringClient composed of a fake XRPPayIDClient and a fake XRPClient which will both succeed.
    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID asynchronously THEN the expected transaction hash is returned.
    let completionCalledExpectation = XCTestExpectation(description: "Completion called")
    xpringClient.send(amount, to: payID, from: wallet) { result in
      switch result {
      case .success(let transactionHash):
        XCTAssertEqual(transactionHash, expectedTransactionHash)
        completionCalledExpectation.fulfill()
      case .failure:
        XCTFail("Error making transaction")
      }
    }

    self.wait(for: [completionCalledExpectation], timeout: 10)
  }

  func testSendSuccessAsyncWithCustomQueue() throws {
    // GIVEN a custom callback queue and a XpringClient which will succeed at sending XRP.
    let queueLabel = "io.xpring.XpringKit.test"
    let customCallbackQueue = DispatchQueue(label: queueLabel)
    DispatchQueue.registerDetection(of: customCallbackQueue)

    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN it is resolved to an address and provided a custom queue
    // THEN the callback is performed on the custom queue.
    let completionCalledExpectation = XCTestExpectation(description: "Completion called")
    xpringClient.send(amount, to: payID, from: wallet, callbackQueue: customCallbackQueue) { _ in
      XCTAssertEqual(DispatchQueue.currentQueueLabel, queueLabel)
      completionCalledExpectation.fulfill()
    }

    self.wait(for: [completionCalledExpectation], timeout: 10)
  }

  func testSendFailureInPayIDAsync() throws {
    // GIVEN a XpringClient composed of an XRPPayIDClient which will throw an error.
    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let payIDClient = FakeXRPPayIDClient(addressResult: .failure(payIDError))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID asynchronously THEN the exception thrown is from Pay ID.
    let completionCalledExpectation = XCTestExpectation(description: "Completion called")
    xpringClient.send(amount, to: payID, from: wallet) { result in
      switch result {
      case .success:
        XCTFail("Should not have produced a transaction hash")
      case .failure(let error):
        XCTAssertEqual(error as? PayIDError, self.payIDError)
        completionCalledExpectation.fulfill()
      }
    }

    self.wait(for: [completionCalledExpectation], timeout: 10)
  }

  func testSendFailureInXRPAsync() throws {
    // GIVEN a XpringClient composed of a XRPClient which will throw an error.
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .failure(xrpError),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID asynchronously THEN the exception thrown is from XRP.
    let completionCalledExpectation = XCTestExpectation(description: "Completion called")
    xpringClient.send(amount, to: payID, from: wallet) { result in
      switch result {
      case .success:
        XCTFail("Should not have produced a transaction hash")
      case .failure(let error):
        XCTAssertEqual(error as? XRPLedgerError, self.xrpError)
        completionCalledExpectation.fulfill()
      }

    }

    self.wait(for: [completionCalledExpectation], timeout: 10)
  }

  func testSendFailureInBothAsync() throws {
    // GIVEN a XpringClient composed of an XRPClient and a PayID client which both throw errors.
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .failure(xrpError),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let payIDClient = FakeXRPPayIDClient(addressResult: .failure(payIDError))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID asynchronously THEN the exception thrown is from Pay ID.
    let completionCalledExpectation = XCTestExpectation(description: "Completion called")
    xpringClient.send(amount, to: payID, from: wallet) { result in
      switch result {
      case .success:
        XCTFail("Should not have produced a transaction hash")
      case .failure(let error):
        XCTAssertEqual(error as? PayIDError, self.payIDError)
        completionCalledExpectation.fulfill()
      }
    }

    self.wait(for: [completionCalledExpectation], timeout: 10)
  }

  func testMismatchedNetworks() throws {
    // GIVEN a PayIDClient and an XRPClient on different networks.
    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      network: .test,
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(xrplNetwork: .main, addressResult: .success(fakeResolvedPayID))

    // WHEN a XpringClient is constructed THEN a mismatched network XpringError is thrown.
    XCTAssertThrowsError(try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)) { error in
      XCTAssertEqual(error as? XpringError, XpringError.mismatchedNetworks)
    }
  }

  func testSendSuccessSync() throws {
    // GIVEN a XpringClient composed of a fake XRPPayIDClient and a fake XRPClient which will both succeed.
    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID synchronously.
    let result = xpringClient.send(amount, to: payID, from: wallet)

    // THEN the expected transaction hash is returned.
    switch result {
    case .success(let transactionHash):
      XCTAssertEqual(transactionHash, expectedTransactionHash)
    case .failure:
      XCTFail("Error making transaction")
    }
  }

  func testSendFailureInPayIDSync() throws {
    // GIVEN a XpringClient composed of an XRPPayIDClient which will throw an error.
    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let payIDClient = FakeXRPPayIDClient(addressResult: .failure(payIDError))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID synchronously.
    let result = xpringClient.send(amount, to: payID, from: wallet)

    // THEN the exception thrown is from PayID.
    switch result {
    case .success:
      XCTFail("Should not have produced a transaction hash")
    case .failure(let error):
      XCTAssertEqual(error as? PayIDError, self.payIDError)
    }
  }

  func testSendFailureInXRPSync() throws {
    // GIVEN a XpringClient composed of a XRPClient which will throw an error.
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .failure(xrpError),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID synchronously.
    let result = xpringClient.send(amount, to: payID, from: wallet)

    // THEN the exception thrown is from XRP.
    switch result {
    case .success:
      XCTFail("Should not have produced a transaction hash")
    case .failure(let error):
      XCTAssertEqual(error as? XRPLedgerError, self.xrpError)
    }
  }

  func testSendFailureInBothSync() throws {
    // GIVEN a XpringClient composed of an XRPClient and a PayID client which both throw errors.
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .failure(xrpError),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue),
      enableDepositAuthValue: .success(fakeEnableDepositAuthValue)
    )

    let payIDClient = FakeXRPPayIDClient(addressResult: .failure(payIDError))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the PayID synchronously.
    let result = xpringClient.send(amount, to: payID, from: wallet)

    // THEN the exception thrown is from Pay ID.
    switch result {
    case .success:
      XCTFail("Should not have produced a transaction hash")
    case .failure(let error):
      XCTAssertEqual(error as? PayIDError, self.payIDError)
    }
  }
}
