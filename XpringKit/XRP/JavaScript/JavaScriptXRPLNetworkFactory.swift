import Foundation
import JavaScriptCore

/// Extends `XRPLNetwork` with JavaScript functionality.
extension XRPLNetwork {
  /// String constants which refer to named JavaScript resources.
  private enum ResourceNames {
    public enum Properties {
      public static let dev = "Dev"
      public static let main = "Main"
      public static let test = "Test"
      public static let xrplNetwork = "XrplNetwork"
    }
  }

  /// A reference to the `XrplNetwork` enum in JavaScript.
  private static let javaScriptXRPLNetwork = JavaScriptLoader.load(ResourceNames.Properties.xrplNetwork)

  internal func toJavascript() -> JSValue {
    switch self {
    case .dev:
      return JavaScriptLoader.load(
        ResourceNames.Properties.dev,
        from: XRPLNetwork.javaScriptXRPLNetwork
      )
    case .test:
      return JavaScriptLoader.load(
        ResourceNames.Properties.test,
        from: XRPLNetwork.javaScriptXRPLNetwork
      )
    case .main:
      return JavaScriptLoader.load(
        ResourceNames.Properties.main,
        from: XRPLNetwork.javaScriptXRPLNetwork
      )
    }
  }
}
