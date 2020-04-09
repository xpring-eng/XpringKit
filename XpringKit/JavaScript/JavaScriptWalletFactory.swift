import JavaScriptCore

/// Provides `JavaScriptWallet` creation logic.
internal class JavaScriptWalletFactory {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public enum Classes {
      public static let wallet = "Wallet"
    }

    public enum Methods {
      public static let generateRandomWallet = "generateRandomWallet"
      public static let generateWalletFromMnemonic = "generateWalletFromMnemonic"
      public static let generateWalletFromSeed = "generateWalletFromSeed"
      public static let getDefaultDerivationPath = "getDefaultDerivationPath"
    }
  }

  /// An underlying reference to a JavaScript wallet.
  private let walletClass: JSValue

  /// Returns the default derivation path used during `Wallet` creation.
  public var defaultDerivationPath: String {
    let result = walletClass.invokeMethod(ResourceNames.Methods.getDefaultDerivationPath, withArguments: [])!
    return result.toString()
  }

  /// Initialize a new `JavaScriptWalletFactory`.
  public init() {
    walletClass = JavaScriptLoader.load(ResourceNames.Classes.wallet)
  }

  /// Generate a new wallet.
  ///
  /// Inputs to the generation process (mnemonic, derivation path) are returned along with a newly generated wallet.
  ///
  /// - Note: This call uses Swift's Math.Random functionality to ensure randomly generated numbers are
  ///         cryptographically secure.
  ///
  /// - Parameter isTest: Whether the address is for use on a test network.
  /// - Returns: Artifacts of the generation process in a WalletGenerationResult.
  public func generateRandomWallet(isTest: Bool = false) -> JavaScriptWalletGenerationResult {
    let randomBytesHex = RandomBytesUtil.randomBytes(numBytes: 16).toHex()
    let result = walletClass.invokeMethod(
      ResourceNames.Methods.generateRandomWallet,
      withArguments: [ randomBytesHex, isTest ]
    )!
    return result.toWalletGenerationResult()!
  }

  /// Initialize a new `Wallet` with a set of keys.
  ///
  /// - Parameters:
  ///   - publicKey: Bytes representing a public key.
  ///   - privateKey: Bytes representing a private key.
  ///   - isTest: Whether the address is for use on a test network.
  /// - Returns: A new wallet if inputs were valid, otherwise nil.
  public func wallet(publicKey: [UInt8], privateKey: [UInt8], isTest: Bool = false) -> JavaScriptWallet? {
    let result = walletClass.construct(withArguments: [publicKey.toHex(), privateKey.toHex(), isTest])!
    return result.toWallet()
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
      arguments.append(JSValue(undefinedIn: .xpringKit) as Any)
    }
    arguments.append(isTest)

    let result = walletClass.invokeMethod(ResourceNames.Methods.generateWalletFromMnemonic, withArguments: arguments)!
    return result.toWallet()
  }

  /// Initialize a new `Wallet` with a base58check encoded seed.
  ///
  /// - Parameters:
  ///   - seed: The seed used to generate the `Wallet`.
  ///   - isTest: Whether the address is for use on a test network.
  /// - Returns: A new wallet if inputs were valid, otherwise nil.
  public func wallet(seed: String, isTest: Bool = false) -> JavaScriptWallet? {
    let result = walletClass.invokeMethod(
      ResourceNames.Methods.generateWalletFromSeed,
      withArguments: [ seed, isTest ]
    )!
    return result.toWallet()
  }
}
