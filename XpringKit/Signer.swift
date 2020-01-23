/// Performs signing operations for the XRP Ledger.
public enum Signer {
    /// The underlying JavaScript backed signer which will sign objects.
    private static let javaScriptSigner = JavaScriptSigner()

    /// Sign a transaction.
    ///
    /// - Parameters:
    ///    - transaction: The `Transaction` to sign.
    ///    - wallet: The wallet which will sign the transaction.
    /// - Returns: A `SignedTransaction` derived from the inputs.
    public static func sign(_ transaction: Rpc_V1_Transaction,
                            with wallet: Wallet) -> [UInt8]? {
        return javaScriptSigner.sign(transaction, with: wallet)
    }
}
