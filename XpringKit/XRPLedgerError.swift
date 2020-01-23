/// Errors that may occur when interacting with the XRP Ledger.
public enum XRPLedgerError: Error {
    /// A problem occurred while performing the cryptographic signing process.
    case signingError
    /// An invalid address was given. The invalid addresss is provided as an associated value.
    case invalidAddress(String)

    /// An invalid address was given. A more descriptive string is provided as an associated value.
    case invalidInputs(String)

    /// An invalid address was given. A more descriptive string is provided as an associated value.
    case unknown(String)
}
