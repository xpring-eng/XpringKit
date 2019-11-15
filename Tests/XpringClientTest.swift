import BigInt
import XCTest
@testable import XpringKit

final class XpringClientTest: XCTestCase {
	static let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
	static let destinationAddress = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"
	static let sendAmount = BigUInt(stringLiteral: "20")

	static let feeDrops = "15"
	static let balance = BigUInt(stringLiteral: "1000")
	static let sequence: UInt64 = 2
	static let accountInfo = Io_Xpring_AccountInfo.with {
		$0.balance = Io_Xpring_XRPAmount.with {
			$0.drops = String(balance)
		}
		$0.sequence = sequence
	}

	static let fee = Io_Xpring_Fee.with {
		$0.amount = Io_Xpring_XRPAmount.with {
			$0.drops = feeDrops
		}
	}

  static let ledgerSequence = Io_Xpring_LedgerSequence.with {
    $0.index = 12
  }

	static let transactionBlobHex = "DEADBEEF"
	static let submitTransactionResponse = Io_Xpring_SubmitSignedTransactionResponse.with {
		$0.transactionBlob = transactionBlobHex
	}

  /// A network client that always succeeds.
  static let successfulFakeNetworkClient = FakeNetworkClient(
    accountInfoResult: .success(XpringClientTest.accountInfo),
    feeResult: .success(XpringClientTest.fee),
    submitSignedTransactionResult: .success(XpringClientTest.submitTransactionResponse),
    latestValidatedLedgerSequenceResult: .success(XpringClientTest.ledgerSequence)
  )

	// MARK: - Balance

	func testGetBalanceWithSuccess() {
		// GIVEN a Xpring client which will successfully return a balance from a mocked network call.
    let xpringClient = XpringClient(networkClient: XpringClientTest.successfulFakeNetworkClient)

		// WHEN the balance is requested.
    guard let balance = try? xpringClient.getBalance(for: XpringClientTest.destinationAddress) else {
			XCTFail("Exception should not be thrown when trying to get a balance")
			return
		}

		// THEN the balance is correct.
		XCTAssertEqual(balance, XpringClientTest.balance)
	}

  func testGetBalanceWithClassicAddress() {
    // GIVEN a classic address.
    guard let classicAddressComponents = Utils.decode(xAddress: XpringClientTest.destinationAddress) else {
      XCTFail("Failed to decode X-Address.")
      return
    }
    let xpringClient = XpringClient(networkClient: XpringClientTest.successfulFakeNetworkClient)

    // WHEN the balance is requested THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.getBalance(for: classicAddressComponents.classicAddress))
  }

	func testGetBalanceWithFailure() {
		// GIVEN a Xpring client which will throw an error when a balance is requested.
		let networkClient = FakeNetworkClient(
			accountInfoResult: .failure(XpringKitTestError.mockFailure),
			feeResult: .success(XpringClientTest.fee),
      submitSignedTransactionResult: .success(XpringClientTest.submitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(XpringClientTest.ledgerSequence)
		)
		let xpringClient = XpringClient(networkClient: networkClient)

		// WHEN the balance is requested THEN the error is thrown.
		XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
	}

	// MARK: - Send

	func testSendWithSuccess() {
		// GIVEN a Xpring client which will successfully return a balance from a mocked network call.
    let xpringClient = XpringClient(networkClient: XpringClientTest.successfulFakeNetworkClient)

		// WHEN XRP is sent.
		guard
			let transactionHash = try? xpringClient.send(
				XpringClientTest.sendAmount,
				to: XpringClientTest.destinationAddress,
				from: XpringClientTest.wallet)
		else {
			XCTFail("Exception should not be thrown when trying to send XRP")
			return
		}

		// THEN the engine result code is as expected.
    XCTAssertEqual(transactionHash, Utils.toTransactionHash(transactionBlobHex: XpringClientTest.transactionBlobHex))
	}

  func testSendWithClassicAddress() {
    // GIVEN a classic address.
    guard let classicAddressComponents = Utils.decode(xAddress: XpringClientTest.destinationAddress) else {
      XCTFail("Failed to decode X-Address.")
      return
    }
    let xpringClient = XpringClient(networkClient: XpringClientTest.successfulFakeNetworkClient)

    // WHEN XRP is sent to a classic address THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      XpringClientTest.sendAmount,
      to: classicAddressComponents.classicAddress,
      from: XpringClientTest.wallet
    ))
  }

  func testSendWithInvalidAddress() {
    // GIVEN a Xpring client and an invalid destination address.
    let xpringClient = XpringClient(networkClient: XpringClientTest.successfulFakeNetworkClient)
    let destinationAddress = "xrp"

    // WHEN XRP is sent to an invalid address THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      XpringClientTest.sendAmount,
      to: destinationAddress,
      from: XpringClientTest.wallet
    ))
  }

	func testSendWithAccountInfoFailure() {
		// GIVEN a Xpring client which will fail to return account info.
		let networkClient = FakeNetworkClient(
			accountInfoResult: .failure(XpringKitTestError.mockFailure),
			feeResult: .success(XpringClientTest.fee),
			submitSignedTransactionResult: .success(XpringClientTest.submitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(XpringClientTest.ledgerSequence)
		)
		let xpringClient = XpringClient(networkClient: networkClient)

		// WHEN a send is attempted then an error is thrown.
		XCTAssertThrowsError(try xpringClient.send(
			XpringClientTest.sendAmount,
			to: XpringClientTest.destinationAddress,
			from: XpringClientTest.wallet
		))
	}

	func testSendWithFeeFailure() {
		// GIVEN a Xpring client which will fail to return a fee.
		let networkClient = FakeNetworkClient(
			accountInfoResult: .success(XpringClientTest.accountInfo),
			feeResult: .failure(XpringKitTestError.mockFailure),
			submitSignedTransactionResult: .success(XpringClientTest.submitTransactionResponse),
      latestValidatedLedgerSequenceResult: .success(XpringClientTest.ledgerSequence)
		)
		let xpringClient = XpringClient(networkClient: networkClient)

		// WHEN a send is attempted then an error is thrown.
		XCTAssertThrowsError(try xpringClient.send(
			XpringClientTest.sendAmount,
			to: XpringClientTest.destinationAddress,
			from: XpringClientTest.wallet
		))
	}

  func testSendWithLatestLedgerSequenceFailure() {
    // GIVEN a Xpring client which will fail to return the latest validated ledger sequence.
    let networkClient = FakeNetworkClient(
      accountInfoResult: .success(XpringClientTest.accountInfo),
      feeResult: .success(XpringClientTest.fee),
      submitSignedTransactionResult: .success(XpringClientTest.submitTransactionResponse),
      latestValidatedLedgerSequenceResult: .failure(XpringKitTestError.mockFailure)
    )
    let xpringClient = XpringClient(networkClient: networkClient)

    // WHEN a send is attempted then an error is thrown.
    XCTAssertThrowsError(try xpringClient.send(
      XpringClientTest.sendAmount,
      to: XpringClientTest.destinationAddress,
      from: XpringClientTest.wallet
    ))
  }

	func testSendWithSubmitFailure() {
		// GIVEN a Xpring client which will fail to submit a transaction.
		let networkClient = FakeNetworkClient(
			accountInfoResult: .success(XpringClientTest.accountInfo),
			feeResult: .success(XpringClientTest.fee),
			submitSignedTransactionResult: .failure(XpringKitTestError.mockFailure),
      latestValidatedLedgerSequenceResult: .success(XpringClientTest.ledgerSequence)
		)
		let xpringClient = XpringClient(networkClient: networkClient)

		// WHEN a send is attempted then an error is thrown.
		XCTAssertThrowsError(try xpringClient.send(
			XpringClientTest.sendAmount,
			to: XpringClientTest.destinationAddress,
			from: XpringClientTest.wallet
		))
	}
}
