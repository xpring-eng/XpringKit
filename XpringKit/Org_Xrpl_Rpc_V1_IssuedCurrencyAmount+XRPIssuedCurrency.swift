import BigInt

internal extension XRPIssuedCurrency {
  init?(issuedCurrency: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount) {
    guard let value = BigInt(issuedCurrency.value) else {
      return nil
    }

    self.currency = XRPCurrency(currency: issuedCurrency.currency)
    self.value = value
    self.issuer = issuedCurrency.issuer.address
  }
}
