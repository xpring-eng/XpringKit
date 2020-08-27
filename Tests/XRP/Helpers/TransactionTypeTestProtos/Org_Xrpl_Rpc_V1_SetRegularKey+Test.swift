import XpringKit

extension Org_Xrpl_Rpc_V1_SetRegularKey {
  public static let testSetRegularKeyWithKeySet = Org_Xrpl_Rpc_V1_SetRegularKey.with {
    $0.regularKey = Org_Xrpl_Rpc_V1_RegularKey.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testRegularKey
      }
    }
  }

  public static let testSetRegularKeyNoKey = Org_Xrpl_Rpc_V1_SetRegularKey()
}
