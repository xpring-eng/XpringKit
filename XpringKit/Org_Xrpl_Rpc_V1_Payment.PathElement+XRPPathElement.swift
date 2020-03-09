internal extension XRPPathElement {
  init(pathElement: Org_Xrpl_Rpc_V1_Payment.PathElement) {
    self.account = pathElement.hasAccount ? pathElement.account.address : nil
    self.currency = pathElement.hasCurrency ? XRPCurrency(currency: pathElement.currency) : nil
    self.issuer = pathElement.hasIssuer ? pathElement.issuer.address : nil
  }
}
