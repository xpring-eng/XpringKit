import XCTest
@testable import XpringKit

class SignerTests: XCTestCase {
    func testSign() {
      // GIVEN an transaction and a wallet and expected signing artifacts.
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

      // WHEN the transaction is signed.
      let signedSerializedTransaction = Signer.sign(transaction, with: wallet)

      // THEN the serialized transaction is as expected.  
      let expectedSignedSerializedTransaction: [UInt8] = [
        18, 0, 0, 36, 0, 0, 0, 1, 32, 27, 0, 0, 0, 0, 97, 64, 0, 0, 0, 0, 0, 3, 232, 104, 64, 0, 0, 0, 0, 0, 0, 10,
        115, 0, 116, 71, 48, 69, 2, 33, 0, 245, 52, 189, 33, 190, 200, 90, 121, 248, 227, 64, 199, 240, 205, 221, 62,
        60, 86, 192, 156, 67, 148, 18, 99, 33, 169, 238, 71, 131, 186, 192, 140, 2, 32, 99, 219, 236, 23, 154, 161,
        240, 28, 220, 207, 75, 63, 206, 164, 46, 49, 253, 222, 30, 182, 153, 139, 90, 36, 237, 56, 50, 27, 237, 102,
        29, 106, 129, 20, 91, 129, 44, 157, 87, 115, 30, 39, 162, 218, 139, 24, 48, 25, 95, 136, 239, 50, 163, 182,
        131, 20, 181, 247, 98, 121, 138, 83, 213, 67, 160, 20, 202, 248, 178, 151, 207, 248, 242, 249, 55, 232
      ]
      XCTAssertEqual(signedSerializedTransaction, expectedSignedSerializedTransaction)
    }
}
