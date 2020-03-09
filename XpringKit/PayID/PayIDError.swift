/// errors that originate from PayID.
public enum PayIDError: Error {
  /// The payment pointer was invalid.
  /// - Parameter paymentPointer: The invalid payment pointer.
  case invalidPaymentPointer(paymentPointer: String)

  /// The response from PayID was in an unexpected format.
  case malformedResponse

  /// An unknown error occured.
  /// - Parameter error: Details about the error.
  case unknown(error: String?)
}
