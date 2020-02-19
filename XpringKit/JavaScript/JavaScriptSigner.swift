import Foundation
import JavaScriptCore

/// Provides Signer functionality backed by JavaScript.
internal class JavaScriptSigner {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public static let signer = "Signer"
    public static let signTransaction = "signTransaction"
  }

  /// A JavaScriptSerializer which can convert native objects to JavaScript.
  private let javaScriptSerializer: JavaScriptSerializer

  /// The JavaScript Signer Class
  private let signerClass: JSValue

  /// Initialize a new Signer.
  ///
  /// - Note: Initialization will fail if the expected bundle is missing or malformed.
  public init() {
    let context = XRPJavaScriptLoader.XRPJavaScriptContext
    signerClass = XRPJavaScriptLoader.load(ResourceNames.signer, from: context)

    javaScriptSerializer = JavaScriptSerializer(context: context)
  }

  /// Sign a transaction.
  ///
  /// - Parameters:
  ///    - transaction: The `Transaction` to sign.
  ///    - wallet: The wallet which will sign the transaction.
  /// - Returns: A `SignedTransaction` derived from the inputs.
  public func sign(_ transaction: Rpc_V1_Transaction, with wallet: Wallet) -> [UInt8]? {
    guard let javaScriptTransaction = javaScriptSerializer.serialize(transaction: transaction) else {
      return nil
    }
    let javaScriptWallet = javaScriptSerializer.serialize(wallet: wallet)

    let javaScriptSignedBytes = signerClass.invokeMethod(
      ResourceNames.signTransaction,
      withArguments: [javaScriptTransaction, javaScriptWallet]
      )!
    let signedBytes = javaScriptSignedBytes.toArray()
    return signedBytes as? [UInt8]
  }
}
