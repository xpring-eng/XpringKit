import XCTest
import XpringKit

class LegacySignerTests: XCTestCase {
	func testSign() {

        // From
		let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
        let lastValidatedLedgerSequence = UInt32(40)

        let _sender = Rpc_V1_AccountAddress.with {
            $0.address = wallet.address
        }

        // To
        let destinationAddress = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
        let _destination = Rpc_V1_AccountAddress.with {
            $0.address = destinationAddress
        }

        // Amount & Fee
        let xrpAmount = Rpc_V1_CurrencyAmount.with {
            $0.xrpAmount = Rpc_V1_XRPDropsAmount.with {
                $0.drops = UInt64(1)
            }
        }
        let dropsFeeAount = Rpc_V1_XRPDropsAmount.with {
            $0.drops = UInt64(11)
        }

        // Optional
        let invoiceID: String? = "invoiceID"
        let memos: [Rpc_V1_Memo]? = []
        let flags: UInt32? = 0
        let sourceTag: UInt32? = 0
        let accountTransactionID: String? = "accountTransactionID"

        let transaction = Rpc_V1_Transaction.with {
            $0.account = Rpc_V1_AccountAddress.with {
                $0.address = wallet.address
            }
            $0.fee = dropsFeeAount
            $0.sequence = UInt32(lastValidatedLedgerSequence)
            $0.payment = Rpc_V1_Payment.with {
                $0.destination = _destination
                $0.amount = xrpAmount
            }
            // Format For Hex
            if let signingPublicKey = wallet.publicKey.data(using: .utf8) {
                $0.signingPublicKey = signingPublicKey
            }
//            $0.lastLedgerSequence = lastValidatedLedgerSequence + ledgerSequenceMargin
        }
        print(Signer.sign(transaction, with: wallet))
		guard let signedTransaction = Signer.sign(transaction, with: wallet) else {
			XCTFail("Error signing transaction")
			return
		}
        print(signedTransaction.signature)
        print("30450221009EBB075B5140895F818DB8B7B934D515B497A0B65D19192BCCEE83C47BD289BA02201699BB09DDC5305F71CDB9459AFBE50237F2A83F20EBF7A161401D2878C18140")
//		XCTAssertEqual(signedTransaction.transaction, transaction)
		XCTAssertEqual(
            signedTransaction.signature,
            "30450221009EBB075B5140895F818DB8B7B934D515B497A0B65D19192BCCEE83C47BD289BA02201699BB09DDC5305F71CDB9459AFBE50237F2A83F20EBF7A161401D2878C18140".data(using: .utf8)
		)
	}
}
