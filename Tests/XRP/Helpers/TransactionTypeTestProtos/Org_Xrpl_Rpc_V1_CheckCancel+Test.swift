import XpringKit

extension Org_Xrpl_Rpc_V1_CheckCancel {
  public static let testCheckCancelAllFields = Org_Xrpl_Rpc_V1_CheckCancel.with {
    $0.checkID = Org_Xrpl_Rpc_V1_CheckID.with {
      $0.value = .testCheckIdValue!
    }
  }

  public static let testCheckCancelMissingCheckId = Org_Xrpl_Rpc_V1_CheckCancel()
}
