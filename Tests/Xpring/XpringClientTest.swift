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
  private let fakeGetPaymentValue = XRPTransaction(getTransactionResponse: .testGetTransactionResponse)

  ///An amount to send.
  private let amount: UInt64 = 10

  /// A Pay ID to resolve.
  private let payID = "$xpring.money/georgewashington"

  /// A wallet
  private let wallet = FakeWallet(signature: [0, 1, 2, 3])

  /// Errors  to throw.
  private let payIDError = PayIDError.unknown(error: "Test PayID error")
  private let xrpError = XRPLedgerError.unknown("Test XRP error")

  func testSendSuccess() throws {
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
      getPaymentValue: .success(fakeGetPaymentValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the Pay ID THEN the expected transaction hash is returned.
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

  func testSendFailureInPayID() throws {
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
      getPaymentValue: .success(fakeGetPaymentValue)
    )

    let payIDClient = FakeXRPPayIDClient(addressResult: .failure(payIDError))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the Pay ID THEN the exception thrown is from Pay ID.
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

  func testSendFailureInXRP() throws {
    // GIVEN a XpringClient composed of a XRPClient which will throw an error.
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .failure(xrpError),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the Pay ID THEN the exception thrown is from XRP.
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

  func testSendFailureInBoth() throws {
    // GIVEN a XpringClient composed of an XRPClient and a PayID client which both throw errors.
    let xrpClient: XRPClientProtocol = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .failure(xrpError),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue),
      getPaymentValue: .success(fakeGetPaymentValue)
    )

    let payIDClient = FakeXRPPayIDClient(addressResult: .failure(payIDError))

    let xpringClient = try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)

    // WHEN XRP is sent to the Pay ID THEN the exception thrown is from Pay ID.
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
      getPaymentValue: .success(fakeGetPaymentValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakeXRPPayIDClient(xrplNetwork: .main, addressResult: .success(fakeResolvedPayID))

    // WHEN a XpringClient is constructed THEN a mismatched network XpringError is thrown.
    XCTAssertThrowsError(try XpringClient(payIDClient: payIDClient, xrpClient: xrpClient)) { error in
      XCTAssertEqual(error as? XpringError, XpringError.mismatchedNetworks)
    }
  }
}
