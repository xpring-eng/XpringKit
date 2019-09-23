import JavaScriptCore

// TODO(keefertaylor): Rename file
internal class JavaScriptSerializer {
	/// String constants which refer to named JavaScript resources.
	private enum ResourceNames {
		public static let deserializeBinary = "deserializeBinary"
		public static let transaction = "Transaction"
		public static let wallet = "Wallet"
	}

	/// The JavaScript context.
	private let context: JSContext

	/// References to JavaScript functions.
	private let deserializeTransactionFunction: JSValue

	/// References to JavaScript classes.
	private let walletClass: JSValue

	/// Initialize a new JavaScriptSerializer.
	// TODO(keefertaylor): Context needs to get injected so that objects don't move between contexts. Remove this injection when Context exists as a shared Singleton.
	public init(context: JSContext) {
		self.context = context

		walletClass = XRPJavaScriptLoader.load(ResourceNames.wallet, from: context)

		let transactionClass = XRPJavaScriptLoader.load(ResourceNames.transaction, from: context)
		deserializeTransactionFunction = XRPJavaScriptLoader.load(ResourceNames.deserializeBinary, from: transactionClass)
	}

	/// Serialize a `Wallet` to a JavaScript object.
	///
	/// - Parameter wallet: The `Wallet` to serialize.
	///	- Returns: A JSValue representing the object.
	public func serialize(wallet: Wallet) -> JSValue {
		return walletClass.construct(withArguments: [ wallet.publicKey, wallet.privateKey])
	}

	/// Serialize a transaction to a JavaScript object.
	///
	/// - Parameter transaction: The transaction to serialize.
	/// - Returns: A JSValue representing the transaction.
	public func serialize(transaction: Io_Xpring_Transaction) -> JSValue? {
		guard
			let transactionData = try? transaction.serializedData()
		else {
			return nil
		}
		let transactionBytes = [UInt8](transactionData)
		return deserializeTransactionFunction.call(withArguments: [transactionBytes])!
	}
}
