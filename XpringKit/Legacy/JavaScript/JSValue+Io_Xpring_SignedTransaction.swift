import JavaScriptCore

/// Allows conversion of `JSValue` objects to `Io_Xpring_SignedTransaction` objects.
internal extension JSValue {
    private enum ResourceNames {
        public static let serializeBinary = "serializeBinary"
    }

    func toSignedTransaction() -> Io_Xpring_SignedTransaction? {
        let javaScriptBytes = self.invokeMethod(ResourceNames.serializeBinary, withArguments: [])!
        guard let bytes = javaScriptBytes.toArray() as? [UInt8] else {
            return nil
        }

        return try? Io_Xpring_SignedTransaction(serializedData: Data(bytes))
    }
}
