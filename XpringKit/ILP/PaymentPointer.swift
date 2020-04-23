import Foundation

/// A string which conforms to the Payment Pointer specification.
/// - SeeAlso: https://paymentpointers.org/syntax-resolution/
public typealias PaymentPointer = String

public extension PaymentPointer {
  /// The well known path.
  static let paymentPointerWellKnownPath = "/.well-known/pay"
}
