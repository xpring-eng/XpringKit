import JavaScriptCore

/// Helper functions to load common JavaScript functionality for the XRP Ledger.
internal enum XRPJavaScriptLoader {
  /// Resource names
  public enum ResourceNames {
    public enum Objects {
      public static let xpringCommonJS = "XpringCommonJS"
    }
  }

  /// Error messages that can occur while loading resources.
  private enum LoaderErrors {
    /// Missing the requested resource.
    public static let missingResource = "Could not find the requested resource: %s"

    /// Unknown error.
    public static let unknownLoadingError = "Unknown error occurred while loading JavaScript resources for the XRP Ledger. "
  }


  /// Load the default exports of the global variable XpringCommonJS on the XpringKit JSContext.
  ///
  /// This method loads value from `XpringCommonJS.<resourceName>`.
  ///
  /// - Note: This function will crash if the requested resource does not exist.
  ///
  /// - Parameters:
  ///		- resourceName: The name of the resource to load.
  /// - Returns: A `JSValue` referring to the requested resource.
  public static func load(_ resourceName: String) -> JSValue {
    guard
      let xpringCommonJS = JSContext.xpringKit.objectForKeyedSubscript(ResourceNames.Objects.xpringCommonJS),
      !xpringCommonJS.isUndefined
      else {
        fatalError(LoaderErrors.missingResource)
    }

    return load(resourceName, from: xpringCommonJS)
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
