/// Performs signing operations for the XRP Ledger.
public enum Signer {
  /// The underlying JavaScript backed signer which will sign objects.
  private static let javaScriptSigner = JavaScriptSigner()
  
  /// Sign a transaction.
  ///
  /// - Parameters:
  ///		- transaction: The `Transaction` to sign.
  ///		- wallet: The wallet which will sign the transaction.
  /// - Returns: A `SignedTransaction` derived from the inputs.
  public static func sign(_ transaction: Io_Xpring_Transaction, with wallet: Wallet) -> Io_Xpring_SignedTransaction? {
    return javaScriptSigner.sign(transaction, with: wallet)
  }
}
