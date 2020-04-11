/// Conforms to XRPCurrency struct while providing an initializer that can construct an XRPCurrency
/// from an Org_Xrpl_Rpc_V1_Currency
internal extension XRPCurrency {

  /// Constructs an XRPCurrency from an Org_Xrpl_Rpc_V1_Currency
  /// - SeeAlso: [Currency Protocol Buffer] (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/amount.proto#L41)
  ///
  /// - Parameters:
  ///     - currency: a Currency (protobuf object) whose field values will be used to construct an XRPCurrency
  /// - Returns: an XRPCurrency with its fields set via the analogous protobuf fields.
  init(currency: Org_Xrpl_Rpc_V1_Currency) {
    self.name = currency.name
    self.code = currency.code
  }
}
