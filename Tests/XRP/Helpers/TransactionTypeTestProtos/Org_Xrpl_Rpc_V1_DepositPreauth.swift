import XpringKit

extension Org_Xrpl_Rpc_V1_DepositPreauth {
  public static let testDepositPreauthWithAuthorize = Org_Xrpl_Rpc_V1_DepositPreauth.with {
    $0.authorize = Org_Xrpl_Rpc_V1_Authorize.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = "rraUBy8yVKUJho1UiHPx9Pv8M8NPGPa5GL"
      }
    }
  }
  
  public static let testDepositPreauthWithUnauthorize = Org_Xrpl_Rpc_V1_DepositPreauth.with {
    $0.unauthorize = Org_Xrpl_Rpc_V1_Unauthorize.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = "r4AZpDKVoBxVcYUJCWMcqZzyWsHTteC4ZE"
      }
    }
  }
  
  public static let testDepositPreauthWithNoFields = Org_Xrpl_Rpc_V1_DepositPreauth()
}
