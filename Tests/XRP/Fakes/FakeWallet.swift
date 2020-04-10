@testable import XpringKit

/// A fake Wallet which always produces the given signature.
public class FakeWallet: Wallet {
  /// A public key to default to.
  public static let defaultPublicKey =
    try! "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE".toBytes()

  /// A private key to default to.
  public static let defaultPrivateKey =
    try! "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4".toBytes()

  /// The signature that this wallet will always produce.
  private let signature: [UInt8]

  /// Initialize a wallet which will always produce the same signature when asked to sign inputs.
  ///
  /// The wallet will use defaultPublicKey and defaultPrivateKey as a set of keys.
  ///
  /// - Parameter signature: The signature this wallet will produce.
  public convenience init(signature: [UInt8]) {
    self.init(signature: signature, publicKey: FakeWallet.defaultPublicKey, privateKey: FakeWallet.defaultPublicKey)
  }

  /// Initialize a wallet which will always produce the same signature when asked to sign inputs.
  ///
  /// - Parameters:
  ///   -  signature: The signature this wallet will produce.
  ///   - publicKey: A hex encoded string representing a public key.
  ///   - privateKey: A hex encoded string representing a private key.
  public init(signature: [UInt8], publicKey: [UInt8], privateKey: [UInt8]) {
    self.signature = signature

    guard let javaScriptWallet = JavaScriptWalletFactory().wallet(publicKey: publicKey, privateKey: privateKey) else {
      fatalError("Could not produce a wallet with the given keys. Check the key format.")
    }
    super.init(javaScriptWallet: javaScriptWallet)
  }

  /// Return a fake signature for any input.
  ///
  /// - Parameter hex: The hex to sign.
  public override func sign(input: Hex) -> Hex? {
    return self.signature.toHex()
  }
}
