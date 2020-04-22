import Foundation
import XpringKit

extension Org_Xrpl_Rpc_V1_SubmitTransactionResponse {

  static let testSubmitTransactionResponse = Org_Xrpl_Rpc_V1_SubmitTransactionResponse.with {
    // swiftlint:disable force_try
    $0.hash = Data(try! TransactionHash.testTransactionHash.toBytes())
    // swiftlint:enable force_try
  }
}
