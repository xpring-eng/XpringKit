import Foundation

/// An object which provides cryptographic primitives.
public protocol Terram {
    /// Validate if the given address is valid.
    func isValid(address: String) -> Bool
}
