/// Conforms to XRPCurrencyAmount struct while providing an initializer that can construct an XRPCurrencyAmount
/// from an Org_Xrpl_Rpc_V1_CurrencyAmount
internal extension XRPCurrencyAmount {

  /// Constructs an XRPCurrencyAmount from an Org_Xrpl_Rpc_V1_CurrencyAmount
  /// - SeeAlso: [CurrencyAmount Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/amount.proto#L10)
  ///
  /// - Parameters:
  ///     - currencyAmount: an Org_Xrpl_Rpc_V1_CurrencyAmount (protobuf object) whose field values will
  ///                       be used to construct an XRPCurrencyAmount
  /// - Returns: an XRPCurrencyAmount with its fields set via the analogous protobuf fields.
  init?(currencyAmount: Org_Xrpl_Rpc_V1_CurrencyAmount) {
    switch currencyAmount.amount {
    case .issuedCurrencyAmount(let issuedCurrency):
      guard let issuedCurrency = XRPIssuedCurrency(issuedCurrency: issuedCurrency) else {
        return nil
      }
      self.issuedCurrency = issuedCurrency
      self.drops = nil
    case .xrpAmount(let dropsAmount):
      self.drops = dropsAmount.drops
      self.issuedCurrency = nil
    case .none:
      return nil
    }
  }
}
