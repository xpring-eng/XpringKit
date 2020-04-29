import JavaScriptCore

internal class JavaScriptSerializer {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public enum Classes {
      public static let wallet = "Wallet"
      public static let transaction = "Transaction"
    }

    public enum Methods {
      public static let deserializeBinary = "deserializeBinary"
    }
  }

  /// References to JavaScript classes.
  private let walletClass: JSValue
  private let transactionClass: JSValue

  /// Initialize a new JavaScriptSerializer.
  public init() {
    walletClass = JavaScriptLoader.load(ResourceNames.Classes.wallet)
    transactionClass = JavaScriptLoader.load(ResourceNames.Classes.transaction)
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
  public func serialize(transaction: Org_Xrpl_Rpc_V1_Transaction) -> JSValue? {
    guard
      let transactionData = try? transaction.serializedData()
      else {
        return nil
    }
    let transactionBytes = [UInt8](transactionData)
    return transactionClass.invokeMethod(ResourceNames.Methods.deserializeBinary, withArguments: [transactionBytes])!
  }
}
