import Foundation
import JavaScriptCore

/// Provides wallet functionality backed by JavaScript.
internal class JavaScriptWallet {
	/// String constants which refer to named JavaScript resources.
	// TODO(keefertaylor): Wire these
	private enum ResourceNames {
		public static let getAddress = "getAddress"
	}

	/// An underlying reference to a JavaScript wallet.
	private let javaScriptWallet: JSValue

	/// Returns the address of this `JavaScriptWallet` on the XRP Ledger.
	public var address: Address {
		let value = javaScriptWallet.invokeMethod("getAddress", withArguments: [])!
		return value.toString()
	}

	/// Returns a hex encoded public key corresponding to this `JavaScriptWallet`.
	public var publicKey: String {
		let value = javaScriptWallet.invokeMethod("getPublicKey", withArguments: [])!
		return value.toString()
	}

	/// Returns a hex encoded private key corresponding to this `JavaScriptWallet`.
	public var privateKey: String {
		let value = javaScriptWallet.invokeMethod("getPrivateKey", withArguments: [])!
		return value.toString()
	}

	/// Initialize a new JavaScriptWallet.
	///
	/// - Parameter javaScriptWallet: A reference to a JavaScript wallet.
	public init?(javaScriptWallet: JSValue) {
		guard !javaScriptWallet.isUndefined else {
			return nil
		}
		self.javaScriptWallet = javaScriptWallet
	}

	/// Sign the given input.
	///
	/// - Parameter input: Input to sign.
	/// - Returns: A hexadecimal encoded signature.
	public func sign(input: Hex) -> String? {
		let result = javaScriptWallet.invokeMethod("sign", withArguments: [ input ])!
		guard !result.isUndefined else {
			return nil
		}
		return result.toString()
	}

	/// TODO(keefertaylor): Implement.
	/// TODO(keefertaylor): Document.
	public func verify() -> Bool {
		return false
	}
}
