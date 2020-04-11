import BigInt

/// Conforms to XRPIssuedCurrency struct while providing an initializer that can construct an XRPIssuedCurrency
/// from an Org_Xrpl_Rpc_V1_IssuedCurrencyAmount
internal extension XRPIssuedCurrency {
  /// Constructs an XRPIssuedCurrency from an Org_Xrpl_Rpc_V1_IssuedCurrencyAmount
  /// - SeeAlso: [IssuedCurrencyAmount Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/amount.proto#L28)
  ///
  /// - Parameters:
  ///     - issuedCurrency: an IssuedCurrencyAmount (protobuf object) whose field values will be used
  ///                       to construct an XRPIssuedCurrency
  /// - Returns: an XRPIssuedCurrency with its fields set via the analogous protobuf fields.
  init?(issuedCurrency: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount) {
    guard let value = BigInt(issuedCurrency.value) else {
      return nil
    }

    self.currency = XRPCurrency(currency: issuedCurrency.currency)
    self.value = value
    self.issuer = issuedCurrency.issuer.address
  }
}
