import Foundation
import XpringKit

extension Rpc_V1_SubmitTransactionResponse {

  static let testSubmitTransactionResponse = Rpc_V1_SubmitTransactionResponse.with {
    $0.hash = Data(try! TransactionHash.testTransactionHash.toBytes())
  }
}
