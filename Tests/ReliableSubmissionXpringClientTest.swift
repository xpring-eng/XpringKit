import XCTest
@testable import XpringKit

final class ReliableSubmissionClientTest: XCTestCase {
  let defaultBalanceValue: UInt64 = 0
  let defaultTransactionStatusValue: TransactionStatus = .succeeded
  let defaultSendValue = "DEADBEEF"
  let defaultLastestValidatedLedgerValue: UInt32 = 10
  let defaultRawTransactionStatusValue = RawTransactionStatus(
    transactionStatus: Io_Xpring_TransactionStatus.with {
      $0.validated = true
      $0.transactionStatusCode = "tesSuccess"
      $0.lastLedgerSequence = 100
    }
  )
  let defaultPaymentHistoryValue: [XRPTransaction] = [ .testTransaction, .testTransaction, .testTransaction ]
  let defaultAccountExistsValue = true

  var fakeXRPClient: FakeXRPClient!
  var reliableSubmissionClient: ReliableSubmissionXRPClient!

  override func setUp() {
    fakeXRPClient = FakeXRPClient(
      getBalanceValue: defaultBalanceValue,
      transactionStatusValue: defaultTransactionStatusValue,
      sendValue: defaultSendValue,
      latestValidatedLedgerValue: defaultLastestValidatedLedgerValue,
      rawTransactionStatusValue: defaultRawTransactionStatusValue,
      paymentHistoryValue: defaultPaymentHistoryValue,
      accountExistsValue: defaultAccountExistsValue
    )

    reliableSubmissionClient = ReliableSubmissionXRPClient(decoratedClient: fakeXRPClient)
  }

  func testGetBalance() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN a balance is retrieved THEN the result is returned unaltered.
    XCTAssertEqual(try? reliableSubmissionClient.getBalance(for: .testAddress), defaultBalanceValue)
  }

  func testGetTransactionStatus() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN a transaction status is retrieved THEN the result is returned unaltered.
    XCTAssertEqual(try? reliableSubmissionClient.getTransactionStatus(for: .testTransactionHash), defaultTransactionStatusValue)
  }

  func testGetLatestValidatedLedgerSequence() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN the latest ledger sequence is retrieved THEN the result is returned unaltered.
    XCTAssertEqual(try? reliableSubmissionClient.getLatestValidatedLedgerSequence(), defaultLastestValidatedLedgerValue)
  }

  func testGetRawTransactionStatus() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN a raw transaction status is retrieved THEN the result is returned unaltered.
    XCTAssertEqual(try? reliableSubmissionClient.getRawTransactionStatus(for: .testTransactionHash), defaultRawTransactionStatusValue)
  }

  func testGetTransactionHistory() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN transaction history is retrieved THEN the result is returned unaltered.
    XCTAssertEqual(
      try? reliableSubmissionClient.paymentHistory(for: .testAddress),
      defaultPaymentHistoryValue
    )
  }

  func testSendWithExpiredLedgerSequenceAndUnvalidatedTransaction() throws {
    // GIVEN A ledger sequence number that will increment in 60s.
    let lastLedgerSequence: UInt32 = 20
    fakeXRPClient.rawTransactionStatusValue = RawTransactionStatus(
      transactionStatus: Io_Xpring_TransactionStatus.with {
        $0.validated = false
        $0.lastLedgerSequence = lastLedgerSequence
        $0.transactionStatusCode = "tesSuccess"
      }
    )
    runAfterOneSecond({ self.fakeXRPClient.latestValidatedLedgerValue = lastLedgerSequence + 1 })

    // WHEN a reliable send is submitted
    let expectation = XCTestExpectation(description: "Send returned")
    do {
      _ = try reliableSubmissionClient.send(UInt64(10), to: .testAddress, from: .testWallet)
      expectation.fulfill()
    } catch {
      XCTFail("Caught unexpected error while calling `send`: \(error)")
    }

    // THEN the function returns
    self.wait(for: [ expectation ], timeout: 10)
  }

  func testSendWithUnexpiredLedgerSequenceAndValidatedTransaction() throws {
    // GIVEN A ledger sequence number that will increment in 60s.
    let lastLedgerSequence: UInt32 = 20
    fakeXRPClient.rawTransactionStatusValue = RawTransactionStatus(
      transactionStatus: Io_Xpring_TransactionStatus.with {
        $0.validated = false
        $0.lastLedgerSequence = lastLedgerSequence
        $0.transactionStatusCode = "tesSuccess"
      }
    )
    runAfterOneSecond {
      self.fakeXRPClient.rawTransactionStatusValue = RawTransactionStatus(
        transactionStatus: Io_Xpring_TransactionStatus.with {
          $0.validated = true
          $0.lastLedgerSequence = lastLedgerSequence
          $0.transactionStatusCode = "tesSuccess"
        }
      )
    }

    // WHEN a reliable send is submitted
    let expectation = XCTestExpectation(description: "Send returned")
    do {
      _ = try reliableSubmissionClient.send(UInt64(10), to: .testAddress, from: .testWallet)
      expectation.fulfill()
    } catch {
      XCTFail("Caught unexpected error while calling `send`: \(error)")
    }

    // THEN the function returns
    self.wait(for: [ expectation ], timeout: 10)
  }

  func testSendWithNoLastLedgerSequence() throws {
    // GIVEN a `ReliableSubmissionXRPClient` decorating a `FakeXRPClient` which will return a transaction that did not have a last ledger sequence attached.
    fakeXRPClient.rawTransactionStatusValue = RawTransactionStatus(
      transactionStatus: Io_Xpring_TransactionStatus.with {
        $0.validated = false
        $0.transactionStatusCode = "tesSuccess"
      }
    )

    // WHEN a reliable send is submitted THEN an error is thrown.
    XCTAssertThrowsError(try reliableSubmissionClient.send(UInt64(10), to: .testAddress, from: .testWallet))
  }

  // MARK: - Helpers

  func runAfterOneSecond(_ task: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: (.now() + 1)) { task() }
  }
}
