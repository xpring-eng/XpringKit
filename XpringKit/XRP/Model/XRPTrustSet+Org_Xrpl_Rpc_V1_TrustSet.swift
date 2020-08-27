import Foundation

/// Conforms to XRPTrustSet struct while providing an initializer that can construct
/// an XRPTrustSet from an Org_Xrpl_Rpc_V1_TrustSet
internal extension XRPTrustSet {

  /// Constructs an XRPTrustSet from an Org_Xrpl_Rpc_V1_TrustSet
  /// - SeeAlso: [TrustSet Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L312)
  ///
  /// - Parameters:
  ///     - trustSet: an Org_Xrpl_Rpc_V1_TrustSet (protobuf object) whose
  ///                            field values will be used to construct an XRPTrustSet
  /// - Returns: an XRPTrustSet with its fields set via the analogous protobuf fields.
  init?(trustSet: Org_Xrpl_Rpc_V1_TrustSet) {
    // limitAmount is required and must be convertable to an XRPCurrencyAmount
    guard trustSet.hasLimitAmount else {
      return nil
    }
    guard let limitAmount = XRPCurrencyAmount(currencyAmount: trustSet.limitAmount.value) else {
      return nil
    }
    self.limitAmount = limitAmount

    self.qualityIn = trustSet.hasQualityIn ? trustSet.qualityIn.value : nil
    self.qualityOut = trustSet.hasQualityOut ? trustSet.qualityOut.value : nil
  }
}
