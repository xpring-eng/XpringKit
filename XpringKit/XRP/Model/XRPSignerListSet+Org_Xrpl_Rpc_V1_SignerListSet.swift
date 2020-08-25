import Foundation

/// Conforms to XRPSignerListSet struct while providing an initializer that can construct
/// an XRPSignerListSet from an Org_Xrpl_Rpc_V1_SignerListSet
internal extension XRPSignerListSet {

  /// Constructs an XRPSignerListSet from an Org_Xrpl_Rpc_V1_SignerListSet
  /// - SeeAlso: [SignerListSet Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L298)
  ///
  /// - Parameters:
  ///     - signerListSet: an Org_Xrpl_Rpc_V1_SignerListSet (protobuf object) whose
  ///                            field values will be used to construct an XRPSignerListSet
  /// - Returns: an XRPSignerListSet with its fields set via the analogous protobuf fields.
  init?(signerListSet: Org_Xrpl_Rpc_V1_SignerListSet) {
    if !signerListSet.hasSignerQuorum {
      return nil
    }
    self.signerQuorum = signerListSet.signerQuorum.value

    self.signerEntries = !signerListSet.signerEntries.isEmpty
      ? signerListSet.signerEntries.map { signerEntry in XRPSignerEntry(signerEntry: signerEntry)! }
      : nil
  }
}
