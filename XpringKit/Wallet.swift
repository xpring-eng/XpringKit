public struct WalletGenerationResult {
	public let mnemonic: String
	public let derivationPath: String
	public let wallet: Wallet
}

internal struct WalletGenerationResultJS {
	public let mnemonic: String
	public let derivationPath: String
	public let wallet: WalletJS
}

public class Wallet {
	// Probably make these static?
	// Consider injection
	private static let walletFactory = WalletJSFactory()!

	private let walletJS: WalletJS

	public var address: String { return walletJS.address }

	public static func generateRandomWallet() -> WalletGenerationResult {
		let walletGenerationResultJS = Wallet.walletFactory.generateRandomWallet()
		return WalletGenerationResult(
			mnemonic: walletGenerationResultJS.mnemonic,
			derivationPath: walletGenerationResultJS.derivationPath,
			wallet: Wallet(walletJS: walletGenerationResultJS.wallet)
		)
	}

	public convenience init(mnemonic: String, derivationPath: String) {
		let walletJS = Wallet.walletFactory.wallet(mnemonic: mnemonic, derivationPath: derivationPath)
		self.init(walletJS: walletJS)
	}

	public convenience init(seed: String) {
		let walletJS = Wallet.walletFactory.wallet(seed: seed)
		self.init(walletJS: walletJS)
	}

	internal init(walletJS: WalletJS) {
		self.walletJS = walletJS
	}
}
