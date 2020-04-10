import Foundation
import XCTest
import XpringKit

final class XpringClientTest: XCTestCase {
  /// Default values for FakeXRPClient. These values must be provided but are not varied in testing.
  private let fakeBalanceValue = 10
  private let fakeTransactionStatusValue = TransactionStatus.succeeded
  private let fakeLastLedgerSequenceValue = 10
  private let fakeRawTransactionStatusValue = RawTransactionStatus(
    getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse()
  )
  private let fakePaymentHistoryValue: [XRPTransaction] = []
  private let fakeAccountExistsValue = true

  ///An amount to send.
  private let amount = 10

  /// A Pay ID to resolve.
  private let payID = "$xpring.money/georgewashington"

  /// A wallet
  private let wallet = FakeWallet(signature: [0, 1, 2, 3])

  /// Errors  to throw.
  private let payIDError = PayIDError.unknown(error: "Test PayID error")
  private let xrpError = XRPError.unknown(error: "Test XRP error")

  func testSendSuccess() throws {
    // GIVEN a XpringClient composed of a fake PayIDClient and a fake XRPClient which will both succeed.
    let expectedTransactionHash = "deadbeefdeadbeefdeadbeef"
    let xrpClient = FakeXRPClient(
      getBalanceValue: .success(fakeBalanceValue),
      paymentStatusValue: .success(fakeTransactionStatusValue),
      sendValue: .success(expectedTransactionHash),
      latestValidatedLedgerValue: .success(fakeLastLedgerSequenceValue),
      rawTransactionStatusValue: .success(fakeRawTransactionStatusValue),
      paymentHistoryValue: .success(fakePaymentHistoryValue),
      accountExistsValue: .success(fakeAccountExistsValue)
    )

    let fakeResolvedPayID = "r123"
    let payIDClient = FakePayIDClient(addressResult: .success(fakeResolvedPayID))

    let xpringClient = XpringClient(payIDClient, xrpClient)

    // WHEN XRP is sent to the Pay ID.
    let transactionHash = xpringClient.send(amount, payID, wallet)

    // THEN the returned hash is correct and no error was thrown.
    XCTAssertEqual(transactionHash, expectedTransactionHash)
  }
}
//
//  @SuppressWarnings("checkstyle:AbbreviationAsWordInName")
//  @Test
//  public void testSendFailureInPayID() throws PayIDException, XRPException {
//    // GIVEN a XpringClient composed of a PayIDClient which will throw an error.
//    String expectedTransactionHash = "deadbeefdeadbeefdeadbeef";
//    XRPClientInterface xrpClient = new FakeXRPClient(
//        XRPLNetwork.TEST,
//        Result.ok(FAKE_BALANCE_VALUE),
//        Result.ok(FAKE_TRANSACTION_STATUS_VALUE),
//        Result.ok(expectedTransactionHash),
//        Result.ok(FAKE_LAST_LEDGER_SEQUENCE_VALUE),
//        Result.ok(DEFAULT_RAW_TRANSACTION_STATUS_VALUE),
//        Result.ok(FAKE_PAYMENT_HISTORY_VALUE),
//        Result.ok(FAKE_ACCOUNT_EXISTS_VALUE)
//    );
//
//    PayIDClientInterface payIDClient = new FakePayIDClient(XRPLNetwork.TEST, Result.error(PAY_ID_EXCEPTION));
//
//    XpringClient xpringClient = new XpringClient(payIDClient, xrpClient);
//
//    // WHEN XRP is sent to the Pay ID THEN the exception thrown is from Pay ID.
//    expectedException.expect(PayIDException.class);
//    xpringClient.send(AMOUNT, PAY_ID, this.wallet);
//  }
//
//  @SuppressWarnings("checkstyle:AbbreviationAsWordInName")
//  @Test
//  public void testSendFailureInXRP() throws PayIDException, XRPException {
//    // GIVEN a XpringClient composed of a XRPClient which will throw an error.
//    XRPClientInterface xrpClient = new FakeXRPClient(
//        XRPLNetwork.TEST,
//        Result.ok(FAKE_BALANCE_VALUE),
//        Result.ok(FAKE_TRANSACTION_STATUS_VALUE),
//        Result.error(XRP_EXCEPTION),
//        Result.ok(FAKE_LAST_LEDGER_SEQUENCE_VALUE),
//        Result.ok(DEFAULT_RAW_TRANSACTION_STATUS_VALUE),
//        Result.ok(FAKE_PAYMENT_HISTORY_VALUE),
//        Result.ok(FAKE_ACCOUNT_EXISTS_VALUE)
//    );
//
//    String fakeResolvedPayID = "r123";
//    PayIDClientInterface payIDClient = new FakePayIDClient(XRPLNetwork.TEST, Result.ok(fakeResolvedPayID));
//
//    XpringClient xpringClient = new XpringClient(payIDClient, xrpClient);
//
//    // WHEN XRP is sent to the Pay ID THEN the exception thrown is from XRP.
//    expectedException.expect(XRPException.class);
//    xpringClient.send(AMOUNT, PAY_ID, this.wallet);
//  }
//
//  @SuppressWarnings("checkstyle:AbbreviationAsWordInName")
//  @Test
//  public void testSendFailureInBoth() throws PayIDException, XRPException {
//    // GIVEN a XpringClient composed of an XRPClient and a PayID client which both throw errors.
//    XRPClientInterface xrpClient = new FakeXRPClient(
//        XRPLNetwork.TEST,
//        Result.ok(FAKE_BALANCE_VALUE),
//        Result.ok(FAKE_TRANSACTION_STATUS_VALUE),
//        Result.error(XRP_EXCEPTION),
//        Result.ok(FAKE_LAST_LEDGER_SEQUENCE_VALUE),
//        Result.ok(DEFAULT_RAW_TRANSACTION_STATUS_VALUE),
//        Result.ok(FAKE_PAYMENT_HISTORY_VALUE),
//        Result.ok(FAKE_ACCOUNT_EXISTS_VALUE)
//    );
//
//    PayIDClientInterface payIDClient = new FakePayIDClient(XRPLNetwork.TEST, Result.error(PAY_ID_EXCEPTION));
//
//    XpringClient xpringClient = new XpringClient(payIDClient, xrpClient);
//
//    // WHEN XRP is sent to the Pay ID THEN the exception thrown is from Pay ID.
//    expectedException.expect(PayIDException.class);
//    xpringClient.send(AMOUNT, PAY_ID, this.wallet);
//  }
//}
