import JavaScriptCore

/// Allows conversion of `JSValue` objects to `Io_Xpring_SignedTransaction` objects.
internal extension JSValue {
    private enum ResourceNames {
        public static let serializeBinary = "serializeBinary"
    }

    func toTransaction() -> Rpc_V1_Transaction? {
        let javaScriptBytes = self.invokeMethod(ResourceNames.serializeBinary, withArguments: [])!
        guard let bytes = javaScriptBytes.toArray() as? [UInt8] else {
            return nil
        }

        return try? Rpc_V1_Transaction(serializedData: Data(bytes))
    }
}
