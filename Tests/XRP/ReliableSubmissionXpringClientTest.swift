import XCTest
@testable import XpringKit

final class ReliableSubmissionClientTest: XCTestCase {
  let defaultBalanceValue: UInt64 = 0
  let defaultTransactionStatusValue: TransactionStatus = .succeeded
  let defaultSendValue = "DEADBEEF"
  let defaultLatestValidatedLedgerValue: UInt32 = 10
  let defaultRawTransactionStatusValue = RawTransactionStatus(
    getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
        $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
          $0.value = 100
        }
      }
      $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
        $0.transactionResult = Org_Xrpl_Rpc_V1_TransactionResult.with {
          $0.result = "tesSuccess"
        }
      }
      $0.validated = true
    }
  )
  let defaultPaymentHistoryValue: [XRPTransaction] = [ .testTransaction, .testTransaction, .testTransaction ]
  let defaultAccountExistsValue = true
  let defaultGetPaymentValue = XRPTransaction(getTransactionResponse: .testGetTransactionResponse, xrplNetwork: XRPLNetwork.test)

  var fakeXRPClient: FakeXRPClient!
  var reliableSubmissionClient: ReliableSubmissionXRPClient!

  override func setUp() {
    super.setUp()

    fakeXRPClient = FakeXRPClient(
      getBalanceValue: .success(defaultBalanceValue),
      paymentStatusValue: .success(defaultTransactionStatusValue),
      sendValue: .success(defaultSendValue),
      latestValidatedLedgerValue: .success(defaultLatestValidatedLedgerValue),
      rawTransactionStatusValue: .success(defaultRawTransactionStatusValue),
      paymentHistoryValue: .success(defaultPaymentHistoryValue),
      accountExistsValue: .success(defaultAccountExistsValue),
      getPaymentValue: .success(defaultGetPaymentValue)
    )

    reliableSubmissionClient = ReliableSubmissionXRPClient(
      decoratedClient: fakeXRPClient,
      xrplNetwork: fakeXRPClient.xrplNetwork
    )
  }

  func testGetBalance() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN a balance is retrieved
    // THEN the result is returned unaltered.
    XCTAssertEqual(try? reliableSubmissionClient.getBalance(for: .testAddress), defaultBalanceValue)
  }

  func testPaymentStatus() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN a transaction status is retrieved
    // THEN the result is returned unaltered.
    XCTAssertEqual(
      try? reliableSubmissionClient.paymentStatus(for: .testTransactionHash),
      defaultTransactionStatusValue
    )
  }

  func testGetLatestValidatedLedgerSequence() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN the latest ledger sequence is retrieved
    // THEN the result is returned unaltered.
    XCTAssertEqual(
      try? reliableSubmissionClient.getLatestValidatedLedgerSequence(address: .testAddress),
      defaultLatestValidatedLedgerValue
    )
  }

  func testGetRawTransactionStatus() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN a raw transaction status is retrieved
    // THEN the result is returned unaltered.
    XCTAssertEqual(
      try? reliableSubmissionClient.getRawTransactionStatus(for: .testTransactionHash),
      defaultRawTransactionStatusValue
    )
  }

  func testPaymentHistory() {
    // GIVEN a `ReliableSubmissionClient` decorating a FakeXRPClient WHEN transaction history is retrieved
    // THEN the result is returned unaltered.
    XCTAssertEqual(
      try? reliableSubmissionClient.paymentHistory(for: .testAddress),
      defaultPaymentHistoryValue
    )
  }

  func testSendWithExpiredLedgerSequenceAndUnvalidatedTransaction() throws {
    // GIVEN A ledger sequence number that will increment in 60s.
    let lastLedgerSequence: UInt32 = 20
    fakeXRPClient.rawTransactionStatusValue = .success(RawTransactionStatus(
      getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
        $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
          $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
            $0.value = lastLedgerSequence
          }
        }
        $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
          $0.transactionResult = Org_Xrpl_Rpc_V1_TransactionResult.with {
            $0.result = "tesSuccess"
          }
        }
        $0.validated = false
      }
    ))
    runAfterOneSecond { self.fakeXRPClient.latestValidatedLedgerValue = .success(lastLedgerSequence + 1) }

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
    fakeXRPClient.rawTransactionStatusValue = .success(RawTransactionStatus(
      getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
        $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
          $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
            $0.value = lastLedgerSequence
          }
        }
        $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
          $0.transactionResult = Org_Xrpl_Rpc_V1_TransactionResult.with {
            $0.result = "tesSuccess"
          }
        }
        $0.validated = false
      }
    ))
    runAfterOneSecond {
      self.fakeXRPClient.rawTransactionStatusValue = .success(RawTransactionStatus(
        getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
          $0.transaction = Org_Xrpl_Rpc_V1_Transaction.with {
            $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
              $0.value = lastLedgerSequence
            }
          }
          $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
            $0.transactionResult = Org_Xrpl_Rpc_V1_TransactionResult.with {
              $0.result = "tesSuccess"
            }
          }
          $0.validated = true
        }
      )
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
    // GIVEN a `ReliableSubmissionXRPClient` decorating a `FakeXRPClient` which will return a transaction
    // that did not have a last ledger sequence attached.
    fakeXRPClient.rawTransactionStatusValue = .success(RawTransactionStatus(
      getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
        $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
          $0.transactionResult = Org_Xrpl_Rpc_V1_TransactionResult.with {
            $0.result = "tesSuccess"
          }
        }
        $0.validated = false
      }
    ))

    // WHEN a reliable send is submitted THEN an error is thrown.
    XCTAssertThrowsError(try reliableSubmissionClient.send(UInt64(10), to: .testAddress, from: .testWallet))
  }

  // MARK: - Helpers

  func runAfterOneSecond(_ task: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: (.now() + 1)) { task() }
  }
}
