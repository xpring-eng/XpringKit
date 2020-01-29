import XpringKit

extension Rpc_V1_GetAccountInfoResponse {
  static let testGetAccountInfoResponse = Rpc_V1_GetAccountInfoResponse.with {
    $0.accountData = Rpc_V1_AccountRoot.with {
      $0.balance = Rpc_V1_XRPDropsAmount.with {
        $0.drops = .balance
      }
    }
  }
}
