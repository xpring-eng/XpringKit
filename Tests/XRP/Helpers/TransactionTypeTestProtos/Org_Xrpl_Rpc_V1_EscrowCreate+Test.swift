import XpringKit

extension Org_Xrpl_Rpc_V1_EscrowCreate {
  public static let testEscrowCreateAllFields = Org_Xrpl_Rpc_V1_EscrowCreate.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.testAmountIssuedCurrencyAmount
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
      $0.value = .testDestinationTag
    }
    $0.cancelAfter = Org_Xrpl_Rpc_V1_CancelAfter.with {
      $0.value = .testCancelAfterValue
    }
    $0.finishAfter = Org_Xrpl_Rpc_V1_FinishAfter.with {
      $0.value = .testFinishAfterValue
    }
    $0.condition = Org_Xrpl_Rpc_V1_Condition.with {
      $0.value = .testConditionValue
    }
  }

  public static let testEscrowCreateMandatoryFields = Org_Xrpl_Rpc_V1_EscrowCreate.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.testAmountIssuedCurrencyAmount
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
  }

  public static let testEscrowCreateMissingDestination = Org_Xrpl_Rpc_V1_EscrowCreate.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.testAmountIssuedCurrencyAmount
  }
}
