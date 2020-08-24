import XpringKit

extension Org_Xrpl_Rpc_V1_CheckCash {
  public static let testCheckCashWithAmount = Org_Xrpl_Rpc_V1_CheckCash.with {
    $0.checkID = Org_Xrpl_Rpc_V1_CheckID.with {
      $0.value = .testCheckIdValue
    }
    $0.amount = .testAmountXrpDrops
  }

  public static let testCheckCashWithDeliverMin = Org_Xrpl_Rpc_V1_CheckCash.with {
    $0.checkID = Org_Xrpl_Rpc_V1_CheckID.with {
      $0.value = .testCheckIdValue
    }
    $0.deliverMin = Org_Xrpl_Rpc_V1_DeliverMin.with {
      $0.value = .testCurrencyAmountIssuedCurrency
    }
  }

  public static let testCheckCashMissingCheckId = Org_Xrpl_Rpc_V1_CheckCash()
}
