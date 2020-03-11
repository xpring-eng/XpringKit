import XpringKit

extension Org_Xrpl_Rpc_V1_GetTransactionResponse {
  static let testGetTransactionResponse = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
    $0.transaction = .testTransaction
  }
}
