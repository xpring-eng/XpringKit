import Foundation

/// Conforms to XRPSetRegularKey struct while providing an initializer that can construct
/// an XRPSetRegularKey from an Org_Xrpl_Rpc_V1_SetRegularKey
internal extension XRPSetRegularKey {

  /// Constructs an XRPSetRegularKey from an Org_Xrpl_Rpc_V1_SetRegularKey
  /// - SeeAlso: [SetRegularKey Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L298)
  ///
  /// - Parameters:
  ///     - setRegularKey: an Org_Xrpl_Rpc_V1_SetRegularKey (protobuf object) whose
  ///                            field values will be used to construct an XRPSetRegularKey
  /// - Returns: an XRPSetRegularKey with its fields set via the analogous protobuf fields.
  init?(setRegularKey: Org_Xrpl_Rpc_V1_SetRegularKey) {
    self.regularKey = setRegularKey.hasRegularKey
      ? setRegularKey.regularKey.value.address
      : nil
  }
}
