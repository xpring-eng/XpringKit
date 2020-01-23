import XCTest
@testable import XpringKit

class SignerTests: XCTestCase {
    func testSign() {
      // GIVEN an transaction and a wallet and expected signing artifacts.
      let fakeSignature = "DEADBEEF"
//      let wallet = FakeWallet(fakeSignature: fakeSignature)
      let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!

      let value: UInt64 = 1_000
      let destination = "XVPcpSm47b1CZkf5AkKM9a84dQHe3m4sBhsrA4XtnBECTAc"
      let fee: UInt64 = 10
      let sequence: UInt32 = 1
      let account = "X7vjQVCddnQ7GCESYnYR3EdpzbcoAMbPw7s2xv8YQs94tv4"

      let transaction = Rpc_V1_Transaction.with {
        $0.account = Rpc_V1_AccountAddress.with {
          $0.address = account
        }

        $0.fee = Rpc_V1_XRPDropsAmount.with {
          $0.drops = fee
        }

        $0.sequence = sequence

        $0.payment = Rpc_V1_Payment.with {
          $0.destination = Rpc_V1_AccountAddress.with {
            $0.address = destination
          }

          $0.amount = Rpc_V1_CurrencyAmount.with {
            $0.xrpAmount = Rpc_V1_XRPDropsAmount.with {
              $0.drops = value
            }
          }
        }
      }

      let expectedTransactionHex = "30450221009EBB075B5140895F818DB8B7B934D515B497A0B65D19192BCCEE83C47BD289BA02201699BB09DDC5305F71CDB9459AFBE50237F2A83F20EBF7A161401D2878C18140"

      let signedBytes = Signer.sign(transaction, with: wallet)

      print(signedBytes)

//
//
//      // Encode transaction with the expected signature.
//      const expectedSignedTransactionJSON = Serializer.transactionToJSON(
//        transaction,
//        fakeSignature,
//      )
//      const expectedSignedTransactionHex = rippleCodec.encode(
//        expectedSignedTransactionJSON,
//      )
//      const expectedSignedTransaction = Utils.toBytes(
//        expectedSignedTransactionHex,
//      )
//
//      // WHEN the transaction is signed with the wallet.
//      const signedTransaction = Signer.signTransaction(transaction, wallet)
//
//      // THEN the signing artifacts are as expected.
//      assert.exists(signedTransaction)
//      assert.deepEqual(signedTransaction, expectedSignedTransaction)
//
//
//
//
//        let transaction = Io_Xpring_Transaction.with {
//            $0.sequence = 40
//            $0.account = wallet.address
//            $0.fee = Io_Xpring_XRPAmount.with {
//                $0.drops = "12"
//            }
//            $0.payment = Io_Xpring_Payment.with {
//                $0.xrpAmount = Io_Xpring_XRPAmount.with {
//                    $0.drops = "1"
//                }
//                $0.destination = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
//            }
//            $0.signingPublicKeyHex = wallet.publicKey
//        }
//
//        guard let signedTransaction = LegacySigner.sign(transaction, with: wallet) else {
//            XCTFail("Error signing transaction")
//            return
//        }
//
//        XCTAssertEqual(signedTransaction.transaction, transaction)
//        XCTAssertEqual(
//            signedTransaction.transactionSignatureHex,
//            "30450221009EBB075B5140895F818DB8B7B934D515B497A0B65D19192BCCEE83C47BD289BA02201699BB09DDC5305F71CDB9459AFBE50237F2A83F20EBF7A161401D2878C18140"
//        )
    }
}
