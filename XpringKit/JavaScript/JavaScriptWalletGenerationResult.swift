/// A property bag which contains artifacts from generating a new `JSWallet`.
internal struct JavaScriptWalletGenerationResult {
    /// The mnemonic that was used to generate the new `Wallet`.
    public let mnemonic: String

    /// The derivation path that was used to generate the new `Wallet`.
    public let derivationPath: String

    /// The newly generated `JavaScriptWallet`.
    public let wallet: JavaScriptWallet
}
