import XpringKit

extension Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse {
  static let testTransactionHistoryResponse = Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse.with {
    $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = .testAddress
    }
  }
}
