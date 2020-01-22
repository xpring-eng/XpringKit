import JavaScriptCore

/// Provides `JavaScriptWallet` creation logic.
internal class JavaScriptWalletFactory {
    /// String constants which refer to named JavaScript resources.
    private enum ResourceNames {
        public static let wallet = "Wallet"
        public static let generateRandomWallet = "generateRandomWallet"
        public static let generateWalletFromMnemonic = "generateWalletFromMnemonic"
        public static let generateWalletFromSeed = "generateWalletFromSeed"
        public static let getDefaultDerivationPath = "getDefaultDerivationPath"
    }

    /// Native javaScript functions used to create `JavaScriptWallet` objects.
    private let generateRandomWalletFunction: JSValue
    private let generateWalletFromMnemonicFunction: JSValue
    private let generateWalletFromSeedFunction: JSValue
    private let getDefaultDerivationPathFunction: JSValue

    /// Returns the default derivation path used during `Wallet` creation.
    public var defaultDerivationPath: String {
        let result = getDefaultDerivationPathFunction.call(withArguments: [])!
        return result.toString()
    }

    /// Initialize a new `JavaScriptWalletFactory`.
    public init() {
        let context = XRPJavaScriptLoader.XRPJavaScriptContext

        let wallet = XRPJavaScriptLoader.load(ResourceNames.wallet, from: context)
        generateRandomWalletFunction = XRPJavaScriptLoader.load(ResourceNames.generateRandomWallet, from: wallet)
        generateWalletFromMnemonicFunction = XRPJavaScriptLoader.load(ResourceNames.generateWalletFromMnemonic, from: wallet)
        generateWalletFromSeedFunction = XRPJavaScriptLoader.load(ResourceNames.generateWalletFromSeed, from: wallet)
        getDefaultDerivationPathFunction = XRPJavaScriptLoader.load(ResourceNames.getDefaultDerivationPath, from: wallet)
    }

    /// Generate a new wallet.
    ///
    /// Inputs to the generation process (mnemonic, derivation path) are returned along with a newly generated wallet.
    ///
    /// - Note: This call uses Swift's Math.Random functionality to ensure randomly generated numbers are cryptographically secure.
    ///
    /// - Parameter isTest: Whether the address is for use on a test network.
    /// - Returns: Artifacts of the generation process in a WalletGenerationResult.
    public func generateRandomWallet(isTest: Bool = false) -> JavaScriptWalletGenerationResult {
        let randomBytesHex = RandomBytesUtil.randomBytes(numBytes: 16).toHex()
        let result = generateRandomWalletFunction.call(withArguments: [ randomBytesHex, isTest ])!
        return result.toWalletGenerationResult()!
    }

    /// Initialize a new `Wallet` with a mnemonic and a derivation path.
    ///
    /// - Parameters:
    ///		- mnemonic: A space delimited list of seed words for the `Wallet`.
    ///		- derivationPath: A derivation path for the `Wallet`. If nil, the default derivation path will be used.
    ///   - isTest: Whether the address is for use on a test network.
    /// - Returns: A new wallet if inputs were valid, otherwise nil.
    public func wallet(mnemonic: String, derivationPath: String? = nil, isTest: Bool = false) -> JavaScriptWallet? {
        var arguments: [Any] = [mnemonic]
        if let derivationPath = derivationPath {
            arguments.append(derivationPath)
        } else {
            arguments.append(JSValue(undefinedIn: XRPJavaScriptLoader.XRPJavaScriptContext) as Any)
        }
        arguments.append(isTest)

        let result = generateWalletFromMnemonicFunction.call(withArguments: arguments)!
        return result.toWallet()
    }

    /// Initialize a new `Wallet` with a base58check encoded seed.
    ///
    /// - Parameters:
    ///   - seed: The seed used to generate the `Wallet`.
    ///   - isTest: Whether the address is for use on a test network.
    /// - Returns: A new wallet if inputs were valid, otherwise nil.
    public func wallet(seed: String, isTest: Bool = false) -> JavaScriptWallet? {
        let result = generateWalletFromSeedFunction.call(withArguments: [ seed, isTest ])!
        return result.toWallet()
    }
}
