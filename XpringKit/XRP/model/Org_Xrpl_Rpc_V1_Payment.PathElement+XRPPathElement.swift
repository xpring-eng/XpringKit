/// Conforms to XRPPathElement struct while providing an initializer that can construct an XRPPathElement
/// from an Org_Xrpl_Rpc_V1_Payment.PathElement
internal extension XRPPathElement {

  /// Constructs an XRPPathElement from an Org_Xrpl_Rpc_V1_Payment.PathElement
  /// - SeeAlso: [PathElement Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L227)
  ///
  /// - Parameters:
  ///     - pathElement: an Org_Xrpl_Rpc_V1_Payment.PathElement (protobuf object) whose field values will be used to
  ///             construct an XRPPathElement
  /// - Returns: an XRPPathElement with its fields set via the analogous protobuf fields.
  init(pathElement: Org_Xrpl_Rpc_V1_Payment.PathElement) {
    self.account = pathElement.hasAccount ? pathElement.account.address : nil
    self.currency = pathElement.hasCurrency ? XRPCurrency(currency: pathElement.currency) : nil
    self.issuer = pathElement.hasIssuer ? pathElement.issuer.address : nil
  }
}
