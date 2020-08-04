import XpringKit

extension Org_Xrpl_Rpc_V1_GetAccountInfoResponse {
  static let testGetAccountInfoResponse = Org_Xrpl_Rpc_V1_GetAccountInfoResponse.with {
    $0.accountData = Org_Xrpl_Rpc_V1_AccountRoot.with {
      $0.balance = Org_Xrpl_Rpc_V1_Balance.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
            $0.drops = .testBalance
          }
        }
      }
    }
  }
}
