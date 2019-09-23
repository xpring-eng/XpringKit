import Foundation
import JavaScriptCore

/// Provides Signer functionality backed by JavaScript.
internal class JavaScriptSigner {
	/// String constants which refer to named JavaScript resources.
	private enum ResourceNames {
	}

	/// The JavaScript context.
	private let context: JSContext

	/// A JavaScriptSerializer which can convert native objects to JavaScript.
	private let javaScriptSerializer: JavaScriptSerializer

	/// Native JavaScript functions wrapped by this class.
	private let signFunction: JSValue
	private let transactionClass: JSValue

	/// Initialize a new Signer.
	///
	/// - Note: Initialization will fail if the expected bundle is missing or malformed.
	public init() {
		context = XRPJavaScriptLoader.XRPJavaScriptContext

		let signer = XRPJavaScriptLoader.load("Signer", from: context)
		signFunction = XRPJavaScriptLoader.load("signTransaction", from: signer)

		javaScriptSerializer = JavaScriptSerializer(context: context)

		// TODO(keefer): Drop some of these classes.
		transactionClass = XRPJavaScriptLoader.load("Transaction", from: context)
	}

	public func sign(_ transaction: Io_Xpring_Transaction, with wallet: Wallet) -> Io_Xpring_SignedTransaction? {
		guard let javaScriptTransaction = javaScriptSerializer.serialize(transaction: transaction) else {
			return nil
		}
		let javaScriptWallet = javaScriptSerializer.serialize(wallet: wallet)

		let javaScriptSignedTransaction = signFunction.call(withArguments: [javaScriptTransaction, javaScriptWallet])!
		return javaScriptSignedTransaction.toSignedTransaction()
	}
}
