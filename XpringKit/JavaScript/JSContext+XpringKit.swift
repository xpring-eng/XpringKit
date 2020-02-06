import JavaScriptCore

/// Extension of JSContext to provide a shared singleton of xpring-common-js across all of XpringKit.
/// - See: http://github.com/xpring-eng/xpring-common-js
extension JSContext {
  /// Constant values used to load resources.
  private enum Resources {
    /// The resource name of the webpacked XpringCommonJS JavaScript.
    public static let javaScriptResourceName = "index"

    /// The file extension of the webpacked XpringCommonJS JavaScript.
    public static let javaScriptFileExtension = "js"
  }

  /// Error messages that can occur while loading resources.
  private enum LoaderErrors {
    /// Missing `index.js`
    public static let missingIndexJS = "Could not load JavaScript resources for the XRP Ledger. Check that `index.js` exists and is well formed."

    /// Missing `XpringCommonJS.default` as a global variable.
    public static let missingXpringCommonJS = "Could not find global XpringCommonJS in Context. Check that `XpringCommonJS.default` is defined as a global variable."
  }

  /// A `JSContext` which is initialized with XRP Ledger functionality.
  ///
  /// - Note: This accessor will crash if JavaScript resources are malformed or missing.
  public static let xpringKit: JSContext = {
    let bundle = Bundle(for: XpringClient.self)

    guard let context = JSContext() else {
      fatalError(LoaderErrors.missingIndexJS)
    }

    guard
      let fileURL = bundle.url(
        forResource: Resources.javaScriptResourceName,
        withExtension: Resources.javaScriptFileExtension
      ),
      let javaScript = try? String(contentsOf: fileURL)
    else {
      fatalError(LoaderErrors.missingIndexJS)
    }

    context.evaluateScript(javaScript)
    return context
  }()
}

