import XCTest
import XpringKit

class SignerTests: XCTestCase {
    func testSign() {
        let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!

        let dropsAmount = Io_Xpring_XRPDropsAmount.with {
            $0.drops = UInt64(1)
        }

        let dropsFee = Io_Xpring_XRPDropsAmount.with {
            $0.drops = UInt64(12)
        }

        let xrpAmount = Io_Xpring_CurrencyAmount.with {
            $0.xrpAmount = dropsAmount
        }

        let _sender = Io_Xpring_AccountAddress.with {
            $0.address = wallet.address
        }

        let _destination = Io_Xpring_AccountAddress.with {
            $0.address = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
        }

        let transaction = Io_Xpring_Transaction.with {
            $0.account = _sender
            $0.fee = dropsFee
            $0.sequence = 40
            $0.payment = Io_Xpring_Payment.with {
                $0.destination = _destination
                $0.amount = xrpAmount
            }
            // Format For Hex
            $0.signingPublicKey = wallet.publicKey.data(using: .utf8)!
        }

        guard let signedTransaction = Signer.sign(transaction, with: wallet) else {
            XCTFail("Error signing transaction")
            return
        }

        XCTAssertEqual(signedTransaction.transaction, transaction)
        XCTAssertEqual(
            signedTransaction.transactionSignatureHex,
            "30450221009EBB075B5140895F818DB8B7B934D515B497A0B65D19192BCCEE83C47BD289BA02201699BB09DDC5305F71CDB9459AFBE50237F2A83F20EBF7A161401D2878C18140"
        )
    }
}
