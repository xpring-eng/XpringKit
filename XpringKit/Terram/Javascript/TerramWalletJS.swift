import Foundation
import JavaScriptCore

/// A javascript implementation of cryptographic wallet functions.
public class TerramWalletJS {
	/// The javascript context.
	private let context: JSContext

	private let getDefaultDerivationPathFunction: JSValue
	private let generateRandomWalletFunction: JSValue
	private let generateWalletFromMnemonicFunction: JSValue

	/// Initialize a new TerramJS.
	///
	/// - Note: Initialization will fail if the expected bundle is missing or malformed.
	public init?() {
		// TODO: refactor this to a web pack loader.
		let bundle = Bundle(for: type(of: self))

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
			let getDefaultDerivationPathFunction = wallet.objectForKeyedSubscript("getDefaultDerivationPath"),
			let generateRandomWalletFunction = wallet.objectForKeyedSubscript("generateRandomWallet"),
			let generateWalletFromMnemonicFunction = wallet.objectForKeyedSubscript("generateWalletFromMnemonic"),
			!getDefaultDerivationPathFunction.isUndefined,
			!generateRandomWalletFunction.isUndefined,
			!generateWalletFromMnemonicFunction.isUndefined
		else {
			return nil
		}

		context.setObject(Wallet.self, forKeyedSubscript: "KEEFER" as NSString)

		self.context = context
		self.getDefaultDerivationPathFunction = getDefaultDerivationPathFunction
		self.generateRandomWalletFunction = generateRandomWalletFunction
		self.generateWalletFromMnemonicFunction = generateWalletFromMnemonicFunction
	}
}

extension TerramWalletJS: TerramWallet {
    public func getDefaultDerivationPath() -> String {
        let result = getDefaultDerivationPathFunction.call(withArguments: [])!
        return result.toString()
    }

	public func generateRandomWallet() -> JSWallet {
		let result = generateRandomWalletFunction.call(withArguments: [])!

		let json = context.objectForKeyedSubscript("JSON")
		let stringify = json?.objectForKeyedSubscript("stringify")
		let str = stringify?.call(withArguments: [ result ])

		return JSWallet(value: result)!
	}

	public func generateWallet(mnemonic: String) -> JSWallet? {
		let result = generateWalletFromMnemonicFunction.call(withArguments: [ mnemonic ])!
		return JSWallet(value: result)
	}

	public func generateWallet(mnemonic: String, derivationPath: String) -> JSWallet? {
		let result = generateWalletFromMnemonicFunction.call(withArguments: [ mnemonic, derivationPath ])!
		return JSWallet(value: result)
	}
}
