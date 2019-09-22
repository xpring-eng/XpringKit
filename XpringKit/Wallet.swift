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

// TODO: Expose default derivation path.
public class Wallet {
	// Probably make these static?
	// Consider injection
	private static let walletFactory = WalletJSFactory()!

	private let walletJS: WalletJS

	public var address: String { return walletJS.address }
	public var publicKey: String { return walletJS.publicKey }
	public var privateKey: String { return walletJS.privateKey }

	public static func generateRandomWallet() -> WalletGenerationResult {
		let walletGenerationResultJS = Wallet.walletFactory.generateRandomWallet()
		return WalletGenerationResult(
			mnemonic: walletGenerationResultJS.mnemonic,
			derivationPath: walletGenerationResultJS.derivationPath,
			wallet: Wallet(walletJS: walletGenerationResultJS.wallet)
		)
	}

	public convenience init?(mnemonic: String, derivationPath: String? = nil) {
		guard let walletJS = Wallet.walletFactory.wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
			return nil
		}
		self.init(walletJS: walletJS)
	}

	public convenience init?(seed: String) {
		guard let walletJS = Wallet.walletFactory.wallet(seed: seed) else {
			return nil
		}
		self.init(walletJS: walletJS)
	}

	internal init(walletJS: WalletJS) {
		self.walletJS = walletJS
	}

	public func sign(input: String) -> String? {
		return self.walletJS.sign(input: input)
	}

	public func verify() -> Bool {
		return self.walletJS.verify()
	}
}
