import Foundation
import JavaScriptCore

/// Provides Signer functionality backed by JavaScript.
internal class LegacyJavaScriptSigner {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public static let signer = "Signer"
    public static let signTransaction = "signLegacyTransaction"
  }

  /// A JavaScriptSerializer which can convert native objects to JavaScript.
  private let javaScriptSerializer: JavaScriptSerializer

  /// Native JavaScript functions wrapped by this class.
  private let signTransactionFunction: JSValue

  /// Initialize a new Signer.
  ///
  /// - Note: Initialization will fail if the expected bundle is missing or malformed.
  public init() {
    let context = XRPJavaScriptLoader.XRPJavaScriptContext

    let signer = XRPJavaScriptLoader.load(ResourceNames.signer, from: context)
    signTransactionFunction = XRPJavaScriptLoader.load(ResourceNames.signTransaction, from: signer)

    javaScriptSerializer = JavaScriptSerializer(context: context)
  }

  /// Sign a transaction.
  ///
  /// - Parameters:
  ///		- transaction: The `Transaction` to sign.
  ///		- wallet: The wallet which will sign the transaction.
  /// - Returns: A `SignedTransaction` derived from the inputs.
  public func sign(_ transaction: Io_Xpring_Transaction, with wallet: Wallet) -> Io_Xpring_SignedTransaction? {
    guard let javaScriptTransaction = javaScriptSerializer.serialize(legacyTransaction: transaction) else {
      return nil
    }
    let javaScriptWallet = javaScriptSerializer.serialize(wallet: wallet)

    let javaScriptSignedTransaction = signTransactionFunction.call(withArguments: [javaScriptTransaction, javaScriptWallet])!
    return javaScriptSignedTransaction.toSignedTransaction()
  }
}
