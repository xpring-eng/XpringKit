import Foundation

/// Provides access to common cryptographic utilities.
public protocol TerramUtils {
    /// Validate if the given address is valid.
    func isValid(address: String) -> Bool
}
