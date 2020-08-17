import XpringKit

extension Org_Xrpl_Rpc_V1_AccountSet {
  public static let testAccountSetAllFields = Org_Xrpl_Rpc_V1_AccountSet.with {
    $0.clearFlag_p = Org_Xrpl_Rpc_V1_ClearFlag.with {
      $0.value = .testClearFlagValue
    }
    $0.domain = Org_Xrpl_Rpc_V1_Domain.with {
      $0.value = .testDomainValue
    }
    $0.emailHash = Org_Xrpl_Rpc_V1_EmailHash.with {
      $0.value = .testEmailHashValue
    }
    $0.messageKey = Org_Xrpl_Rpc_V1_MessageKey.with {
      $0.value = .testMessageKeyValue
    }
    $0.setFlag = Org_Xrpl_Rpc_V1_SetFlag.with {
      $0.value = .testSetFlagValue
    }
    $0.transferRate = Org_Xrpl_Rpc_V1_TransferRate.with {
      $0.value = .testTransferRateValue
    }
    $0.tickSize = Org_Xrpl_Rpc_V1_TickSize.with {
      $0.value = .testTickSizeValue
    }
  }

  public static let testAccountSetOneField = Org_Xrpl_Rpc_V1_AccountSet.with {
    $0.clearFlag_p = Org_Xrpl_Rpc_V1_ClearFlag.with {
      $0.value = .testClearFlagValue
    }
  }
}
