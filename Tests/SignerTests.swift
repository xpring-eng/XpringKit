import XCTest
import XpringKit

class SignerTests: XCTestCase {
	func testSign() {
		let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
		let transaction = Io_Xpring_Transaction.with {
			$0.sequence = 40
			$0.account = wallet.address
			$0.fee = Io_Xpring_XRPAmount.with {
				$0.drops = "12"
			}
			$0.payment = Io_Xpring_Payment.with {
				$0.xrpAmount = Io_Xpring_XRPAmount.with {
					$0.drops = "1"
				}
				$0.destination = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
			}
			$0.signingPublicKeyHex = wallet.publicKey
		}

		guard let signedTransaction = Signer.sign(transaction, with: wallet) else {
			XCTFail("Error signing transaction")
			return
		}

		XCTAssertEqual(signedTransaction.transaction, transaction)
		XCTAssertEqual(
			signedTransaction.transactionSignatureHex,
			"304402201AC810C79CC7053A3ECFFB59873D2DB3B5531E87A58E8FCB4D118AB9634DB66202201345DB2A7757D2A6CEA82BD1C1FB8E17204273BD6148BE2CE68F7F32CF937AF9"
		)
	}
}
