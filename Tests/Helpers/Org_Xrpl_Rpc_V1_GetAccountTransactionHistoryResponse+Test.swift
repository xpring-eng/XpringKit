import XpringKit

// TODO(keefertaylor): Refactor Org_Xrpl_Rpc_V1_AccountAddress to be a static test helper object to avoid repetition.
extension Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse {
  static let testTransactionHistoryResponse = Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse.with {
    $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = .testAddress
    }

    $0.transactions = [
      Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
        $0.transaction = .testTransaction
      },
      Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
        $0.transaction = .testTransaction
      }
    ]
  }
}
