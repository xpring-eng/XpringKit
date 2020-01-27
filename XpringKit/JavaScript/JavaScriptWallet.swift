import Foundation
import JavaScriptCore

/// Provides wallet functionality backed by JavaScript.
internal class JavaScriptWallet {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public static let getAddress = "getAddress"
    public static let getPrivateKey = "getPrivateKey"
    public static let getPublicKey = "getPublicKey"
    public static let sign = "sign"
    public static let verify = "verify"
  }
  
  /// An underlying reference to a JavaScript wallet.
  private let javaScriptWallet: JSValue
  
  /// Returns the address of this `JavaScriptWallet` on the XRP Ledger.
  public var address: Address {
    let value = javaScriptWallet.invokeMethod(ResourceNames.getAddress, withArguments: [])!
    return value.toString()
  }
  
  /// Returns a hex encoded public key corresponding to this `JavaScriptWallet`.
  public var publicKey: String {
    let value = javaScriptWallet.invokeMethod(ResourceNames.getPublicKey, withArguments: [])!
    return value.toString()
  }
  
  /// Returns a hex encoded private key corresponding to this `JavaScriptWallet`.
  public var privateKey: String {
    let value = javaScriptWallet.invokeMethod(ResourceNames.getPrivateKey, withArguments: [])!
    return value.toString()
  }
  
  /// Initialize a new JavaScriptWallet.
  ///
  /// - Parameter javaScriptWallet: A reference to a JavaScript wallet.
  public init?(javaScriptWallet: JSValue) {
    guard !javaScriptWallet.isUndefined else {
      return nil
    }
    
    /// An underlying reference to a JavaScript wallet.
    private let javaScriptWallet: JSValue
    
    /// Returns the address of this `JavaScriptWallet` on the XRP Ledger.
    public var address: Address {
      let value = javaScriptWallet.invokeMethod(ResourceNames.getAddress, withArguments: [])!
      return value.toString()
    }
    
    /// Returns a hex encoded public key corresponding to this `JavaScriptWallet`.
    public var publicKey: String {
      let value = javaScriptWallet.invokeMethod(ResourceNames.getPublicKey, withArguments: [])!
      return value.toString()
    }
    
    /// Returns a hex encoded private key corresponding to this `JavaScriptWallet`.
    public var privateKey: String {
      let value = javaScriptWallet.invokeMethod(ResourceNames.getPrivateKey, withArguments: [])!
      return value.toString()
    }
    
    /// Initialize a new JavaScriptWallet.
    ///
    /// - Parameter javaScriptWallet: A reference to a JavaScript wallet.
    public init?(javaScriptWallet: JSValue) {
      guard !javaScriptWallet.isUndefined else {
        return nil
      }
      self.javaScriptWallet = javaScriptWallet
    }
    
    /// Sign the given input.
    ///
    /// - Parameter input: Input to sign.
    /// - Returns: A hexadecimal encoded signature.
    public func sign(input: Hex) -> String? {
      let result = javaScriptWallet.invokeMethod(ResourceNames.sign, withArguments: [ input ])!
      guard !result.isUndefined else {
        return nil
      }
      return result.toString()
    }
    
    /// Verify that a given signature is valid for the given message.
    ///
    /// - Parameters:
    ///		- message: A message in hex format.
    ///		- signature A signature in hex format.
    ///	- Returns: A boolean indicating the validity of the signature.
    public func verify(message: String, signature: String) -> Bool {
      let result = javaScriptWallet.invokeMethod(ResourceNames.verify, withArguments: [message, signature])!
      return result.toBool()
    }
    return result.toString()
  }
  
  /// Verify that a given signature is valid for the given message.
  ///
  /// - Parameters:
  ///		- message: A message in hex format.
  ///		- signature A signature in hex format.
  ///	- Returns: A boolean indicating the validity of the signature.
  public func verify(message: String, signature: String) -> Bool {
    let result = javaScriptWallet.invokeMethod(ResourceNames.verify, withArguments: [message, signature])!
    return result.toBool()
  }
}
