import XpringKit

extension Org_Xrpl_Rpc_V1_OfferCancel {
  public static let testOfferCancelFieldSet = Org_Xrpl_Rpc_V1_OfferCancel.with {
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
  }

  public static let testOfferCancelMissingOfferSequence = Org_Xrpl_Rpc_V1_OfferCancel()
}
