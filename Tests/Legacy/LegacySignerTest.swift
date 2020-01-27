import XCTest
import XpringKit

class LegacySignerTests: XCTestCase {
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

    guard let signedTransaction = LegacySigner.sign(transaction, with: wallet) else {
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
