import Foundation
import JavaScriptCore

internal class JSSigner {
	/// The javascript context.
	private let context: JSContext

	/// A reference to the sign function.
	private let signFunction: JSValue
	private let hexToBytesFunction: JSValue
	private let bytesToHexFunction: JSValue
	private let transactionClass: JSValue
	private let walletClass: JSValue

	/// Initialize a new Signer.
	///
	/// - Note: Initialization will fail if the expected bundle is missing or malformed.
	public init?() {
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
			let signer = `default`.objectForKeyedSubscript("Signer"),
			let transactionClass = `default`.objectForKeyedSubscript("Transaction"),
			let walletClass = `default`.objectForKeyedSubscript("Wallet"),
			let hexToBytesFunction = `default`.objectForKeyedSubscript("fromHexString"),
			let bytesToHexFunction = `default`.objectForKeyedSubscript("toHexString"),
			let signFunction = signer.objectForKeyedSubscript("signTransaction"),
			!signFunction.isUndefined,
			!hexToBytesFunction.isUndefined,
			!transactionClass.isUndefined,
			!walletClass.isUndefined,
			!bytesToHexFunction.isUndefined
		else {
			return nil
		}

		self.context = context

		self.signFunction = signFunction
		self.transactionClass = transactionClass
		self.walletClass = walletClass
		self.hexToBytesFunction = hexToBytesFunction
		self.bytesToHexFunction = bytesToHexFunction
	}

	public func sign(_ transaction: Io_Xpring_Transaction, with wallet: Wallet) -> Io_Xpring_SignedTransaction? {
		print("Transaction: \(transaction)")
		// TODO: remove force try.
		let serializedTransaction = try! transaction.serializedData()
		let serializedTransactionHex = [UInt8](serializedTransaction).toHex()
//		print("Serialized to: \(serializedTransactionHex)")

		// TODO: Could we pass bytes directly?
		let bytes = hexToBytesFunction.call(withArguments: [serializedTransactionHex ])!

		guard
			let deserializeBinaryTransactionFunction = transactionClass.objectForKeyedSubscript("deserializeBinary"),
			!deserializeBinaryTransactionFunction.isUndefined
		else {
			return nil
		}

		let transactionJS = deserializeBinaryTransactionFunction.call(withArguments: [ bytes ] )!
//		print("SEQUENCE: \(transactionJS.invokeMethod("getSequence", withArguments: []))")

		let walletJS = walletClass.construct(withArguments: [ wallet.publicKey, wallet.privateKey])

		let signedTransaction = signFunction.call(withArguments: [transactionJS, walletJS])!
		let serializedSignedTransaction = signedTransaction.invokeMethod("serializeBinary", withArguments: [])!
		let serializedSignedTransactionHex = bytesToHexFunction.call(withArguments: [serializedSignedTransaction])!.toString()!
		let nativeData = serializedSignedTransactionHex.hexadecimal!
		let serializedSignedTransactionNative = try! Io_Xpring_SignedTransaction(serializedData: nativeData)
//		print(serializedSignedTransactionNative)

		print("Serialized Transaction: \(serializedSignedTransactionNative)")
		return serializedSignedTransactionNative
	}
}

extension String {

	/// Create `Data` from hexadecimal string representation
	///
	/// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
	///
	/// - returns: Data represented by this hexadecimal string.

	var hexadecimal: Data? {
		var data = Data(capacity: self.count / 2)

		let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
		regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
			let byteString = (self as NSString).substring(with: match!.range)
			let num = UInt8(byteString, radix: 16)!
			data.append(num)
		}

		guard data.count > 0 else { return nil }

		return data
	}

}
