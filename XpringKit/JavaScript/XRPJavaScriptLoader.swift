import JavaScriptCore

/// Helper functions to load common JavaScript functionality for the XRP Ledger.
internal enum XRPJavaScriptLoader {
  /// Error messages that can occur while loading resources.
  private enum LoaderErrors {
    /// Missing `bundled.js`
    public static let missingBundledJS = "Could not load JavaScript resources for the XRP Ledger. Check that `bundled.js` exists and is well formed."
    
    /// Missing `EntryPoint.default` as a global variable.
    public static let missingEntrypoint = "Could not find global EntryPoint in Context. Check that `EntryPoint.default` is defined as a global variable."
    
    /// Missing the requested resource.
    public static let missingResource = "Could not find the requested resource: %s"
    
    /// Unknown error.
    public static let unknownLoadingError = "Unknown error occurred while loading JavaScript resources for the XRP Ledger. "
  }
  
  /// Constant values used to load resources.
  private enum Resources {
    /// The resource name of the bundled JavaScript.
    public static let javaScriptResourceName = "bundled"
    
    /// The file extension of the bundled JavaScript.
    public static let javaScriptFileExtension = "js"
  }
  
  /// A `JSContext` which is initialized with XRP Ledger functionality.
  ///
  /// - Note: This accessor will crash if JavaScript resources are malformed or missing.
  // TODO(keefertaylor): Migrate to using a singleton context to avoid the heavy lifting of instantiating many `JSContext` objects.
  public static var XRPJavaScriptContext: JSContext {
    let bundle = Bundle(for: XpringClient.self)
    
    guard let context = JSContext() else {
      fatalError(LoaderErrors.missingBundledJS)
    }
    
    guard
      let fileURL = bundle.url(forResource: Resources.javaScriptResourceName, withExtension: Resources.javaScriptFileExtension),
      let javaScript = try? String(contentsOf: fileURL)
      else {
        fatalError(LoaderErrors.missingBundledJS)
    }
    
    context.evaluateScript(javaScript)
    return context
  }
  
  /// Load a class, parameter or function from the default entry point on the given JSContext.
  ///
  /// This method loads value from `EntryPoint.<value>`.
  ///
  /// - Note: This function will crash if the requested resource does not exist.
  ///
  /// - Parameters:
  ///		- resourceName: The name of the resource to load.
  ///		- context: The context to load a resource from.
  /// - Returns: A `JSValue` referring to the requested resource.
  // TODO(keefer): Drop context parameter when context becomes a singleton.
  public static func load(_ resourceName: String, from context: JSContext) -> JSValue {
    guard
      let entrypoint = context.objectForKeyedSubscript("EntryPoint"),
      !entrypoint.isUndefined
      else {
        fatalError(LoaderErrors.missingEntrypoint)
    }
    
    return load(resourceName, from: entrypoint)
  }
  
  /// Load a class, parameter or function as a keyed subscript from the given value.
  ///
  /// - Note: This function will crash if the requested resource does not exist.
  ///
  /// - Parameters:
  ///		- resourceName: The name of the resource to load.
  ///		- value: The value to load a resource from.
  /// - Returns: A `JSValue` referring to the requested resource.
  public static func load(_ resourceName: String, from value: JSValue) -> JSValue {
    guard let resource = failableLoad(resourceName, from: value) else {
      let errorMessage = String(format: LoaderErrors.missingResource, resourceName)
      fatalError(errorMessage)
    }
    
    return resource
  }
  
  /// Load a class, parameter or function as a keyed subscript from the given value.
  ///
  /// - Parameters:
  ///    - resourceName: The name of the resource to load.
  ///    - value: The value to load a resource from.
  /// - Returns: A `JSValue` referring to the requested resource.
  public static func failableLoad(_ resourceName: String, from value: JSValue) -> JSValue? {
    guard
      let resource = value.objectForKeyedSubscript(resourceName),
      !resource.isUndefined
      else {
        return nil
    }
    return resource
  }
}
