import Foundation

/// Conforms to XRPOfferCreate struct while providing an initializer that can construct an XRPOfferCreate
/// from an Org_Xrpl_Rpc_V1_OfferCreate
internal extension XRPOfferCreate {

  /// Constructs an XRPOfferCreate from an Org_Xrpl_Rpc_V1_OfferCreate
  /// - SeeAlso: [OfferCreate Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L212)
  ///
  /// - Parameters:
  ///     - offerCreate: an Org_Xrpl_Rpc_V1_OfferCreate (protobuf object) whose field values will be used to
  ///             construct an XRPOfferCreate
  /// - Returns: an XRPOfferCreate with its fields set via the analogous protobuf fields.
  init?(offerCreate: Org_Xrpl_Rpc_V1_OfferCreate) {

    if let takerGets = XRPCurrencyAmount(currencyAmount: offerCreate.takerGets.value) {
      self.takerGets = takerGets
    } else {
      return nil
    }

    if let takerPays = XRPCurrencyAmount(currencyAmount: offerCreate.takerPays.value) {
      self.takerPays = takerPays
    } else {
      return nil
    }

    self.expiration = offerCreate.hasExpiration ? offerCreate.expiration.value : nil
    self.offerSequence = offerCreate.hasOfferSequence
      ? offerCreate.offerSequence.value
      : nil
  }
}
