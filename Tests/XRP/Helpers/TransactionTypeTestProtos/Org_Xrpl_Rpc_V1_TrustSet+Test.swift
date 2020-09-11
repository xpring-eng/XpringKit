import XpringKit

extension Org_Xrpl_Rpc_V1_TrustSet {
  public static let testTrustSetAllFields = Org_Xrpl_Rpc_V1_TrustSet.with {
    $0.limitAmount = Org_Xrpl_Rpc_V1_LimitAmount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.qualityIn = Org_Xrpl_Rpc_V1_QualityIn.with {
      $0.value = .testQualityInValue
    }
    $0.qualityOut = Org_Xrpl_Rpc_V1_QualityOut.with {
      $0.value = .testQualityOutValue
    }
  }

  public static let testTrustSetMandatoryFields = Org_Xrpl_Rpc_V1_TrustSet.with {
    $0.limitAmount = Org_Xrpl_Rpc_V1_LimitAmount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
  }

  public static let testTrustSetMissingLimitAmount = Org_Xrpl_Rpc_V1_TrustSet.with {
    $0.qualityIn = Org_Xrpl_Rpc_V1_QualityIn.with {
      $0.value = .testQualityInValue
    }
    $0.qualityOut = Org_Xrpl_Rpc_V1_QualityOut.with {
      $0.value = .testQualityOutValue
    }
  }
}
