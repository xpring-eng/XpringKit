import Foundation
import JavaScriptCore

/// Provides an implementation of PayIDUtils in Javascript.
internal class JavaScriptPayIDUtils {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public enum Classes {
      public static let payIDUtils = "PayIDUtils"
    }

    public enum Methods {
      public static let parsePaymentPointer = "parsePaymentPointer"
    }

    public enum Properties {
      public static let host = "host"
      public static let path = "path"
    }
  }

  /// The JavaScript class.
  private let payIDUtilsClass: JSValue

  /// Initialize a JavaScriptPayIDUtils object.
  public init() {
    payIDUtilsClass = XRPJavaScriptLoader.load(ResourceNames.Classes.payIDUtils)
  }

  /// Parse a payment pointer string to a payment pointer object
  ///
  /// - Parameter paymentPointer: The input string payment pointer.
  /// - Returns: A  tuple containing components of the payment pointer if the inputs were valid, otherwise nil.
  public func parse(paymentPointer: String) -> (host: String, path: String)? {
    let result = payIDUtilsClass.invokeMethod(
      ResourceNames.Methods.parsePaymentPointer, withArguments: [ paymentPointer ]
    )!

    guard !result.isUndefined else {
      return nil
    }

    let host = XRPJavaScriptLoader.load(ResourceNames.Properties.host, from: result).toString()!
    let path = XRPJavaScriptLoader.load(ResourceNames.Properties.path, from: result).toString()!

    return (host: host, path: path)
  }
}
