import JavaScriptCore

/// Allows conversion of `JSValue` objects to `JavaScriptWallet` objects.
internal extension JSValue {
    func toWallet() -> JavaScriptWallet? {
        return JavaScriptWallet(javaScriptWallet: self)
    }
}
