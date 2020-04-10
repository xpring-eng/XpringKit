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
      public static let parsePaymentPointer = "parsePayID"
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
    payIDUtilsClass = JavaScriptLoader.load(ResourceNames.Classes.payIDUtils)
  }

  /// Parse the given Pay ID to a set of components.
  ///
  /// - Parameter payID: A PayID to parse.
  /// - Returns: A set of components parsed from the PayID.
  public func parse(payID: String) -> (host: String, path: String)? {
    let result = payIDUtilsClass.invokeMethod(
      ResourceNames.Methods.parsePaymentPointer, withArguments: [ payID ]
    )!

    guard !result.isUndefined else {
      return nil
    }

    let host = JavaScriptLoader.load(ResourceNames.Properties.host, from: result).toString()!
    let path = JavaScriptLoader.load(ResourceNames.Properties.path, from: result).toString()!

    return (host: host, path: path)
  }
}
