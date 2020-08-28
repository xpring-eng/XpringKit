import Foundation

/// Conforms to XRPEscrowFinish struct while providing an initializer that can construct an XRPEscrowFinish
/// from an Org_Xrpl_Rpc_V1_EscrowFinish
internal extension XRPEscrowFinish {

  /// Constructs an XRPEscrowFinish from an Org_Xrpl_Rpc_V1_EscrowFinish
  /// - SeeAlso: [EscrowFinish Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L194)
  ///
  /// - Parameters:
  ///     - escrowFinish: an Org_Xrpl_Rpc_V1_EscrowFinish (protobuf object) whose field values will be used to
  ///             construct an XRPEscrowFinish
  /// - Returns: an XRPEscrowFinish with its fields set via the analogous protobuf fields.
  init?(escrowFinish: Org_Xrpl_Rpc_V1_EscrowFinish, xrplNetwork: XRPLNetwork) {
    if let ownerXAddress = Utils.encode(
      classicAddress: escrowFinish.owner.value.address,
      isTest: xrplNetwork.isTest
      ) {
      self.ownerXAddress = ownerXAddress
    } else {
      return nil
    }

    if escrowFinish.hasOfferSequence {
      self.offerSequence = escrowFinish.offerSequence.value
    } else {
      return nil
    }

    self.condition = escrowFinish.hasCondition
      ? String(decoding: escrowFinish.condition.value, as: UTF8.self)
      : nil

    self.fulfillment = escrowFinish.hasFulfillment
      ? String(decoding: escrowFinish.fulfillment.value, as: UTF8.self)
      : nil
  }
}
