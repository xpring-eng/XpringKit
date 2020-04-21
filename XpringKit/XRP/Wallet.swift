/// Represents an account on the XRP Ledger and provides signing / verifying cryptographic functions.
public class Wallet {
  /// A JavaScript based wallet factory which will generate wallets.
  private static let javaScriptWalletFactory = JavaScriptWalletFactory()

  /// An underlying JavaScript based wallet which will perform cryptographic functions.
  private let javaScriptWallet: JavaScriptWallet

  /// Returns the default derivation path used during `Wallet` creation.
  public static var defaultDerivationPath: String { return javaScriptWalletFactory.defaultDerivationPath }

  /// Returns the address of this `Wallet` on the XRP Ledger.
  public var address: Address { return javaScriptWallet.address }

  /// Returns a hex encoded public key corresponding to this `Wallet`.
  public var publicKey: Hex { return javaScriptWallet.publicKey }

  /// Returns a hex encoded private key corresponding to this `Wallet`.
  public var privateKey: Hex { return javaScriptWallet.privateKey }

  /// Generate a new wallet.
  ///
  /// Inputs to the generation process (mnemonic, derivation path) are returned along with a newly generated wallet.
  ///
  /// - Note: This call uses Swift's Math.Random functionality to ensure randomly generated numbers are
  ///         cryptographically secure.
  ///
  /// - Parameter isTest: Whether the address is for use on a test network.
  /// - Returns: Artifacts of the generation process in a WalletGenerationResult.
  public static func generateRandomWallet(isTest: Bool = false) -> WalletGenerationResult {
    let javaScriptWalletGenerationResult = Wallet.javaScriptWalletFactory.generateRandomWallet(isTest: isTest)
    return WalletGenerationResult(javaScriptWalletGenerationResult: javaScriptWalletGenerationResult)
  }

  /// Initialize a new `Wallet` with a mnemonic and a derivation path.
  ///
  /// - Parameters:
  ///		- mnemonic: A space delimited list of seed words for the `Wallet`.
  ///		- derivationPath: A derivation path for the `Wallet`. If nil, the default derivation path will be used.
  ///   - isTest: Whether the address is for use on a test network.
  /// - Returns: A new wallet if inputs were valid, otherwise nil.
  public convenience init?(mnemonic: String, derivationPath: String? = nil, isTest: Bool = false) {
    guard let javaScriptWallet = Wallet.javaScriptWalletFactory.wallet(
      mnemonic: mnemonic,
      derivationPath: derivationPath,
      isTest: isTest
      ) else {
        return nil
    }
    self.init(javaScriptWallet: javaScriptWallet)
  }

  /// Initialize a new `Wallet` with a base58check encoded seed.
  ///
  /// - Parameters:
  ///   - seed: The seed used to generate the `Wallet`.
  ///   - isTest: Whether the address is for use on a test network.
  /// - Returns: A new wallet if inputs were valid, otherwise nil.
  public convenience init?(seed: String, isTest: Bool = false) {
    guard let javaScriptWallet = Wallet.javaScriptWalletFactory.wallet(seed: seed, isTest: isTest) else {
      return nil
    }
    self.init(javaScriptWallet: javaScriptWallet)
  }

  /// Initialize a new `Wallet` with a set of keys.
  ///
  /// - Parameters:
  ///   - publicKey: Bytes representing a public key.
  ///   - privateKey: Bytes representing a private key.
  ///   - isTest: Whether the address is for use on a test network.
  /// - Returns: A new wallet if inputs were valid, otherwise nil.
  public convenience init?(publicKey: [UInt8], privateKey: [UInt8], isTest: Bool = false) {
    guard let javaScriptWallet = Wallet.javaScriptWalletFactory.wallet(
      publicKey: publicKey,
      privateKey: privateKey,
      isTest: isTest
    ) else {
      return nil
    }
    self.init(javaScriptWallet: javaScriptWallet)
  }

  /// Initialize a new `Wallet` backed by the given JavaScript based wallet.
  internal init(javaScriptWallet: JavaScriptWallet) {
    self.javaScriptWallet = javaScriptWallet
  }

  /// Sign the given input.
  ///
  /// - Parameter input: Input to sign.
  /// - Returns: A hexadecimal encoded signature.
  public func sign(input: Hex) -> Hex? {
    return self.javaScriptWallet.sign(input: input)
  }

  /// Verify that a given signature is valid for the given message.
  ///
  /// - Parameters:
  ///		- message: A message in hex format.
  ///		- signature A signature in hex format.
  ///	- Returns: A boolean indicating the validity of the signature.
  public func verify(message: String, signature: String) -> Bool {
    return self.javaScriptWallet.verify(message: message, signature: signature)
  }
}
