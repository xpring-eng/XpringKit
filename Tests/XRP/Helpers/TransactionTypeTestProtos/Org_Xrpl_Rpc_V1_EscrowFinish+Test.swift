import XpringKit

extension Org_Xrpl_Rpc_V1_EscrowFinish {
  public static let testEscrowFinishAllFields = Org_Xrpl_Rpc_V1_EscrowFinish.with {
    $0.owner = Org_Xrpl_Rpc_V1_Owner.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
    $0.condition = Org_Xrpl_Rpc_V1_Condition.with {
      $0.value = .testConditionValue
    }
    $0.fulfillment = Org_Xrpl_Rpc_V1_Fulfillment.with {
      $0.value = .testFulfillmentValue
    }
  }

  public static let testEscrowFinishMandatoryFields = Org_Xrpl_Rpc_V1_EscrowFinish.with {
    $0.owner = Org_Xrpl_Rpc_V1_Owner.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
  }

  public static let testEscrowFinishMissingOwner = Org_Xrpl_Rpc_V1_EscrowFinish.with {
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
    $0.condition = Org_Xrpl_Rpc_V1_Condition.with {
      $0.value = .testConditionValue
    }
    $0.fulfillment = Org_Xrpl_Rpc_V1_Fulfillment.with {
      $0.value = .testFulfillmentValue
    }
  }
}
