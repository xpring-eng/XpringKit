import XCTest
import XpringKit

class SignerTests: XCTestCase {
    func testSign() {

        // From
        let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!
        let sender = Rpc_V1_AccountAddress.with {
            $0.address = wallet.address
        }

        // To
        let destinationAddress = "XVPcpSm47b1CZkf5AkKM9a84dQHe3m4sBhsrA4XtnBECTAc"
        let destination = Rpc_V1_AccountAddress.with {
            $0.address = destinationAddress
        }

        // Amount & Fee
        let xrpAmount = Rpc_V1_CurrencyAmount.with {
            $0.xrpAmount = Rpc_V1_XRPDropsAmount.with {
                $0.drops = 1
            }
        }
        let dropsFeeAount = Rpc_V1_XRPDropsAmount.with {
            $0.drops = 12
        }

        let transaction = Rpc_V1_Transaction.with {
            $0.sequence = 40
            $0.account = sender
            $0.fee = dropsFeeAount
            $0.payment = Rpc_V1_Payment.with {
                $0.amount = xrpAmount
                $0.destination = destination
            }
            $0.signingPublicKey = Data(Utils.toByteArray(hex: wallet.publicKey))
        }

        guard let signedTransaction = Signer.sign(transaction, with: wallet) else {
            XCTFail("Error signing transaction")
            return
        }

        XCTAssertEqual(signedTransaction, transaction)
        XCTAssertEqual(
            signedTransaction.signature,
            Data("30450221009EBB075B5140895F818DB8B7B934D515B497A0B65D19192BCCEE83C47BD289BA02201699BB09DDC5305F71CDB9459AFBE50237F2A83F20EBF7A161401D2878C18140".utf8)
        )
    }
}
