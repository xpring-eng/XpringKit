import Foundation

/// Conforms to XRPOfferCancel struct while providing an initializer that can construct an XRPOfferCancel
/// from an Org_Xrpl_Rpc_V1_OfferCancel
internal extension XRPOfferCancel {

  /// Constructs an XRPOfferCancel from an Org_Xrpl_Rpc_V1_OfferCancel
  /// - SeeAlso: [OfferCancel Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L206)
  ///
  /// - Parameters:
  ///     - offerCancel: an Org_Xrpl_Rpc_V1_OfferCancel (protobuf object) whose field values will be used to
  ///             construct an XRPOfferCancel
  /// - Returns: an XRPOfferCancel with its fields set via the analogous protobuf fields.
  init?(offerCancel: Org_Xrpl_Rpc_V1_OfferCancel) {
    if offerCancel.hasOfferSequence {
      self.offerSequence = offerCancel.offerSequence.value
    } else {
      return nil
    }
  }
}
