import Foundation

/// Conforms to XRPEscrowCancel struct while providing an initializer that can construct an XRPEscrowCancel
/// from an Org_Xrpl_Rpc_V1_EscrowCancel
internal extension XRPEscrowCancel {

  /// Constructs an XRPEscrowCancel from an Org_Xrpl_Rpc_V1_EscrowCancel
  /// - SeeAlso: [EscrowCancel Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L170)
  ///
  /// - Parameters:
  ///     - escrowCancel: an Org_Xrpl_Rpc_V1_EscrowCancel (protobuf object) whose field values will be used to
  ///             construct an XRPEscrowCancel
  /// - Returns: an XRPEscrowCancel with its fields set via the analogous protobuf fields.
  init?(escrowCancel: Org_Xrpl_Rpc_V1_EscrowCancel, xrplNetwork: XRPLNetwork) {
    guard let ownerXAddress = Utils.encode(
      classicAddress: escrowCancel.owner.value.address,
      isTest: xrplNetwork != XRPLNetwork.main
      ) else {
        return nil
    }
    if !escrowCancel.hasOfferSequence {
      return nil
    }
    self.ownerXAddress = ownerXAddress
    self.offerSequence = escrowCancel.offerSequence.value
  }
}
