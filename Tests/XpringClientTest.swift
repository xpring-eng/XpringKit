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
		print("hello world")
	}	
}
