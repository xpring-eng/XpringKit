/// Conforms to XRPPath struct while providing an initializer that can construct an XRPPath
/// from an Org_Xrpl_Rpc_V1_Payment.Path
internal extension XRPPath {

  /// Constructs an XRPPath from an Org_Xrpl_Rpc_V1_Payment.Path
  /// - SeeAlso: [Path Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L237)
  ///
  /// - Parameters:
  ///     - path: an Org_Xrpl_Rpc_V1_Payment.Path (protobuf object) whose field values will be used to
  ///             construct an XRPPath
  /// - Returns: an XRPPath with its fields set via the analogous protobuf fields.
  init(path: Org_Xrpl_Rpc_V1_Payment.Path) {
    self.pathElements = path.elements.map { pathElement in XRPPathElement(pathElement: pathElement) }
  }
}
