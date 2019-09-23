import Foundation
import JavaScriptCore

internal class JavaScriptWalletFactory {
	/// The javascript context.
	private let context: JSContext

	private let generateRandomWalletFunction: JSValue
	private let generateWalletFromMnemonicFunction: JSValue
	private let generateWalletFromSeedFunction: JSValue
	private let getDefaultDerivationPathFunction: JSValue

	public var defaultDerivationPath: String {
		let result = getDefaultDerivationPathFunction.call(withArguments: [])!
		return result.toString()
	}

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
			let getDefaultDerivationPathFunction = wallet.objectForKeyedSubscript("getDefaultDerivationPath"),
			!generateRandomWalletFunction.isUndefined,
			!generateWalletFromMnemonicFunction.isUndefined,
			!generateWalletFromSeedFunction.isUndefined,
			!getDefaultDerivationPathFunction.isUndefined
		else {
				return nil
		}

		self.context = context
		self.generateRandomWalletFunction = generateRandomWalletFunction
		self.generateWalletFromMnemonicFunction = generateWalletFromMnemonicFunction
		self.generateWalletFromSeedFunction = generateWalletFromSeedFunction
		self.getDefaultDerivationPathFunction = getDefaultDerivationPathFunction
	}

	public func generateRandomWallet() -> JavaScriptWalletGenerationResult {
		let randomBytesHex = RandomBytesUtil.randomBytes(numBytes: 16).toHex()
		let result = generateRandomWalletFunction.call(withArguments: [ randomBytesHex ])!
		return result.toWalletGenerationResult()
	}

	public func wallet(mnemonic: String, derivationPath: String? = nil) -> WalletJS? {
		var arguments = [mnemonic]
		if let derivationPath = derivationPath {
			arguments.append(derivationPath)
		}

		let result = generateWalletFromMnemonicFunction.call(withArguments: arguments)!
		return result.toWallet()
	}

	public func wallet(seed: String) -> WalletJS? {
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

	// TODO: Take a context in here too?
	// TOOD: Shoudl this be failable?
	// TODO: Refactor these strings to be better.
	public init?(value: JSValue) {
		guard
			let publicKey = value.invokeMethod("getPublicKey", withArguments: []),
			let privateKey = value.invokeMethod("getPrivateKey", withArguments: []),
			let address = value.invokeMethod("getAddress", withArguments: []),
			!publicKey.isUndefined,
			!privateKey.isUndefined,
			!address.isUndefined
		else {
			return nil
		}

		javascriptWallet = value

		self.publicKey = publicKey.toString()
		self.privateKey = privateKey.toString()
		self.address = address.toString()
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
