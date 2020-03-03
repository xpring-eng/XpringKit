import Foundation
import XpringKit

extension Org_Xrpl_Rpc_V1_SubmitTransactionResponse {

  static let testSubmitTransactionResponse = Org_Xrpl_Rpc_V1_SubmitTransactionResponse.with {
    $0.hash = Data(try! TransactionHash.testTransactionHash.toBytes())
  }
}
