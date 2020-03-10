internal extension XRPSigner {
  init(signer: Org_Xrpl_Rpc_V1_Signer) {
    self.account = signer.account.value.address
    self.signingPublicKey = signer.signingPublicKey.value
    self.transactionSignature = signer.transactionSignature.value
  }
}
