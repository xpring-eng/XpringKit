import XpringKit

extension Org_Xrpl_Rpc_V1_EscrowCancel {
  public static let testEscrowCancelAllFields = Org_Xrpl_Rpc_V1_EscrowCancel.with {
    $0.owner = Org_Xrpl_Rpc_V1_Owner.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
  }

  public static let testEscrowCancelMissingOwner = Org_Xrpl_Rpc_V1_EscrowCancel.with {
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
  }
}
