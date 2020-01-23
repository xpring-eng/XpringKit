/// A property bag which contains artifacts from generating a new `Wallet`.
public struct WalletGenerationResult {
    /// The underlying JavaScript based `WalletGenerationResult`.
    private let javaScriptWalletGenerationResult: JavaScriptWalletGenerationResult

    /// The mnemonic that was used to generate the new `Wallet`.
    public var mnemonic: String { return javaScriptWalletGenerationResult.mnemonic }

    /// The derivation path that was used to generate the new `Wallet`.
    public var derivationPath: String { return javaScriptWalletGenerationResult.derivationPath }

    /// The newly generated `Wallet`.
    public var wallet: Wallet { return Wallet(javaScriptWallet: javaScriptWalletGenerationResult.wallet) }

    /// Initialize a new `WalletGenerationResult` backed by a JavaScript implementation.
    internal init(javaScriptWalletGenerationResult: JavaScriptWalletGenerationResult) {
        self.javaScriptWalletGenerationResult = javaScriptWalletGenerationResult
    }
}
