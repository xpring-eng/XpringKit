/// Errors that originate from PayID.
public enum PayIDError: Equatable, Error {
  /// The payment pointer was invalid.
  /// - Parameter paymentPointer: The invalid payment pointer.
  case invalidPaymentPointer(paymentPointer: String)

  /// A mapping for the given payment pointer was not found.
  /// - Parameters:
  ///   - paymentPointer: The invalid payment pointer.
  ///   - network: The network resolution was attempted on.
  case mappingNotFound(paymentPointer: String, network: XRPLNetwork)

  /// The response from PayID was in an unexpected format.
  case unexpectedResponse

  /// The functionality is not implemented.
  case unimplemented

  /// An unknown error occurred.
  /// - Parameter error: Details about the error.
  case unknown(error: String? = nil)
}
