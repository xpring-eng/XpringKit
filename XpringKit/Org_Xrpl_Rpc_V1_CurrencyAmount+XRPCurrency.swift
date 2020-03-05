internal extension XRPCurrency {
  init(currency: Org_Xrpl_Rpc_V1_Currency) {
    self.name = currency.name
    self.code = currency.code
  }
}
