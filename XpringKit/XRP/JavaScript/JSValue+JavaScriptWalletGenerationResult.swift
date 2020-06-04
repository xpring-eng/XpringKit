import JavaScriptCore

/// Allows conversion of `JSValue` objects to `JavaScriptWalletGenerationResult` objects.
internal extension JSValue {
  func toWalletGenerationResult() -> JavaScriptWalletGenerationResult? {
    guard
      let mnemonic = self.objectForKeyedSubscript("mnemonic")!.toString(),
      let derivationPath = self.objectForKeyedSubscript("derivationPath")!.toString(),
      let wallet = self.objectForKeyedSubscript("wallet")!.toWallet()
      else {
        return nil
    }

    return JavaScriptWalletGenerationResult(
      mnemonic: mnemonic,
      derivationPath: derivationPath,
      wallet: wallet
    )
  }
}
