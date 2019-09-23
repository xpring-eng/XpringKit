import XCTest
import XpringKit

class SignerTests: XCTestCase {
	func testSign() {
		let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
		let transaction = Io_Xpring_Transaction.with {
			$0.sequence = 14
			$0.account = wallet.address
			$0.fee = Io_Xpring_XRPAmount.with {
				$0.drops = "1"
			}
			$0.payment = Io_Xpring_Payment.with {
				$0.xrpAmount = Io_Xpring_XRPAmount.with {
					$0.drops = "1"
				}
				$0.destination = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
			}
		}
//		transaction.payment = payment

		let signer = Signer()
		signer.sign(transaction, with: wallet)
	}
}
