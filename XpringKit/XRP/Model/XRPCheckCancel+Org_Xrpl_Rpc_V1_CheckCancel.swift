import Foundation

/// Conforms to XRPCheckCancel struct while providing an initializer that can construct an XRPCheckCancel
/// from an Org_Xrpl_Rpc_V1_CheckCancel
internal extension XRPCheckCancel {

  /// Constructs an XRPCheckCancel from an Org_Xrpl_Rpc_V1_CheckCancel
  /// - SeeAlso: [CheckCancel Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L126)
  ///
  /// - Parameters:
  ///     - checkCancel: an Org_Xrpl_Rpc_V1_CheckCancel (protobuf object) whose field values will be used to
  ///             construct an XRPCheckCancel
  /// - Returns: an XRPCheckCancel with its fields set via the analogous protobuf fields.
  init?(checkCancel: Org_Xrpl_Rpc_V1_CheckCancel) {
    self.checkId = String(decoding: checkCancel.checkID.value, as: UTF8.self)
    if self.checkId.isEmpty {
      return nil
    }
  }
}
