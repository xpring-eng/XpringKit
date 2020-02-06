import JavaScriptCore

internal class JavaScriptSerializer {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public enum Classes {
      public static let wallet = "Wallet"
      public static let legacyTransaction = "LegacyTransaction"
      public static let transaction = "Transaction"
    }

    public enum Methods {
      public static let deserializeBinary = "deserializeBinary"
    }
  }

  /// References to JavaScript classes.
  private let walletClass: JSValue
  private let transactionClass: JSValue
  private let legacyTransactionClass: JSValue

  /// Initialize a new JavaScriptSerializer.
  // TODO(keefertaylor): Context needs to get injected so that objects don't move between contexts. Remove this injection when Context exists as a shared Singleton.
  public init(context: JSContext) {
    walletClass = XRPJavaScriptLoader.load(ResourceNames.Classes.wallet, from: context)
    transactionClass = XRPJavaScriptLoader.load(ResourceNames.Classes.transaction, from: context)
    legacyTransactionClass = XRPJavaScriptLoader.load(ResourceNames.Classes.legacyTransaction, from: context)
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
  public func serialize(transaction: Rpc_V1_Transaction) -> JSValue? {
    guard
      let transactionData = try? transaction.serializedData()
      else {
        return nil
    }
    let transactionBytes = [UInt8](transactionData)
    return transactionClass.invokeMethod(ResourceNames.Methods.deserializeBinary, withArguments: [transactionBytes])!
  }

  /// Serialize a legacy transaction to a JavaScript object.
  ///
  /// - Parameter legacyTransaction: The transaction to serialize.
  /// - Returns: A JSValue representing the transaction.
  public func serialize(legacyTransaction: Io_Xpring_Transaction) -> JSValue? {
    guard
      let transactionData = try? legacyTransaction.serializedData()
      else {
        return nil
    }
    let transactionBytes = [UInt8](transactionData)
    return legacyTransactionClass.invokeMethod(ResourceNames.Methods.deserializeBinary, withArguments: [transactionBytes])!
  }
}
