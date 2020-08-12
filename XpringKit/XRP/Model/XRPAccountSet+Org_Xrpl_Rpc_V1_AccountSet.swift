import Foundation

/// Conforms to XRPAccountSet struct while providing an initializer that can construct an XRPAccountSet
/// from an Org_Xrpl_Rpc_V1_AccountSet
internal extension XRPAccountSet {

  /// Constructs an XRPAccountSet from an Org_Xrpl_Rpc_V1_AccountSet
  /// - SeeAlso: [AccountSet Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L100)
  ///
  /// - Parameters:
  ///     - accountSet: an Org_Xrpl_Rpc_V1_AccountSet (protobuf object) whose field values will be used to
  ///             construct an XRPAccountSet
  ///     - xrplNetwork: The XRPL network from which this object was retrieved.
  /// - Returns: an XRPAccountSet with its fields set via the analogous protobuf fields.
  init?(accountSet: Org_Xrpl_Rpc_V1_AccountSet) {
    self.clearFlag = accountSet.hasClearFlag_p ? accountSet.clearFlag_p.value : nil
    self.domain = accountSet.hasDomain ? accountSet.domain.value : nil
    self.emailHash = accountSet.hasEmailHash ? accountSet.emailHash.value : nil
    self.messageKey = accountSet.hasMessageKey ? accountSet.messageKey.value : nil
    self.setFlag = accountSet.hasSetFlag ? accountSet.setFlag.value : nil
    self.transferRate = accountSet.hasTransferRate ? accountSet.transferRate.value : nil
    self.tickSize = accountSet.hasTickSize ? accountSet.tickSize.value : nil
  }
}
