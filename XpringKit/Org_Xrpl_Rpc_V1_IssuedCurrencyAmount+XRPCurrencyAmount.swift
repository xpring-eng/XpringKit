internal extension XRPCurrencyAmount {
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
