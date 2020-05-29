/// Errors that originate from PayID.
public enum PayIDError: Equatable, Error {
  /// The payment pointer was invalid.
  /// - Parameter payID: The invalid PayID.
  case invalidPayID(payID: String)

  /// A mapping for the given payment pointer was not found.
  /// - Parameters:
  ///   - payID: The PayID which failed resolution
  ///   - network: The network resolution was attempted on.
  case mappingNotFound(payID: String, network: String)

  /// The response from PayID was in an unexpected format.
  case unexpectedResponse

  /// The functionality is not implemented.
  case unimplemented

  /// An unknown error occurred.
  /// - Parameter error: Details about the error.
  case unknown(error: String? = nil)
}
