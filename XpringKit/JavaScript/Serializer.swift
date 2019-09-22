import JavaScriptCore

extension JSValue {
	internal func toWalletGenerationResult() -> WalletGenerationResultJS {
		let mnemonic = self.objectForKeyedSubscript("mnemonic")!.toString()!
		let derivationPath = self.objectForKeyedSubscript("derivationPath")!.toString()!
		let wallet = self.objectForKeyedSubscript("wallet")!.toWallet()

		return WalletGenerationResultJS(
			mnemonic: mnemonic,
			derivationPath: derivationPath,
			wallet: wallet
		)
	}

	internal func toWallet() -> WalletJS {
		return WalletJS(value: self)!
	}
}
