import Foundation
import JavaScriptCore

internal class WalletJSFactory {
	/// The javascript context.
	private let context: JSContext

	private let generateRandomWalletFunction: JSValue
	private let generateWalletFromMnemonicFunction: JSValue
	private let generateWalletFromSeedFunction: JSValue

	public init?() {
		let bundle = Bundle(for: type(of: self))

		// TODO: Refactor to a loader class
		guard
			let context = JSContext(),
			let fileURL = bundle.url(forResource: "bundled", withExtension: "js"),
			let javascript = try? String(contentsOf: fileURL)
			else {
				return nil
		}

		context.evaluateScript(javascript)

		guard
			let entrypoint = context.objectForKeyedSubscript("EntryPoint"),
			let `default` = entrypoint.objectForKeyedSubscript("default"),
			let wallet = `default`.objectForKeyedSubscript("Wallet"),
			let generateRandomWalletFunction = wallet.objectForKeyedSubscript("generateRandomWallet"),
			let generateWalletFromMnemonicFunction = wallet.objectForKeyedSubscript("generateWalletFromMnemonic"),
			let generateWalletFromSeedFunction = wallet.objectForKeyedSubscript("generateWalletFromSeed"),
			!generateRandomWalletFunction.isUndefined,
			!generateWalletFromMnemonicFunction.isUndefined,
			!generateWalletFromSeedFunction.isUndefined
		else {
				return nil
		}

		self.context = context
		self.generateRandomWalletFunction = generateRandomWalletFunction
		self.generateWalletFromMnemonicFunction = generateWalletFromMnemonicFunction
		self.generateWalletFromSeedFunction = generateWalletFromSeedFunction
	}

	public func generateRandomWallet() -> WalletGenerationResultJS {
		let result = generateRandomWalletFunction.call(withArguments: [])!
		return result.toWalletGenerationResult()
	}

	public func wallet(mnemonic: String, derivationPath: String) -> WalletJS {
		let result = generateWalletFromMnemonicFunction.call(withArguments: [ mnemonic, derivationPath ])!
		return result.toWallet()
	}

	public func wallet(seed: String) -> WalletJS {
		let result = generateWalletFromSeedFunction.call(withArguments: [ seed ])!
		return result.toWallet()
	}
}

// TOOD: Refactor to JSWallet / JS Utils
internal class WalletJS {
	private let javascriptWallet: JSValue

	public let publicKey: String
	public let privateKey: String
	public let address: String
	public let mnemonic: String
	public let derivationPath: String

	// TODO: Take a context in here too?
	// TOOD: Shoudl this be failable?
	// TODO: Refactor these strings to be better.
	public init?(value: JSValue) {
		guard
			let publicKey = value.invokeMethod("getPublicKey", withArguments: []),
			let privateKey = value.invokeMethod("getPrivateKey", withArguments: []),
			let address = value.invokeMethod("getAddress", withArguments: []),
			let mnemonic = value.invokeMethod("getMnemonic", withArguments: []),
			let derivationPath = value.invokeMethod("getDerivationPath", withArguments: []),
			!publicKey.isUndefined,
			!privateKey.isUndefined,
			!address.isUndefined,
			!mnemonic.isUndefined,
			!derivationPath.isUndefined
			else {
				return nil
		}

		javascriptWallet = value

		self.publicKey = publicKey.toString()
		self.privateKey = privateKey.toString()
		self.address = address.toString()
		self.mnemonic = mnemonic.toString()
		self.derivationPath = derivationPath.toString()
	}

	public func sign(input: String) -> String? {
		let result = javascriptWallet.invokeMethod("sign", withArguments: [ input ])!
		guard !result.isUndefined else {
			return nil
		}
		return result.toString()
	}

	public func verify() -> Bool {
		return false
	}
}
