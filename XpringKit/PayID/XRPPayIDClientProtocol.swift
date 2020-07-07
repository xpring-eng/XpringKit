import Foundation

/// A protocol for an XRP PayID client.
public protocol XRPPayIDClientProtocol {
  /// The network that addresses will be resolved on.
  var xrplNetwork: XRPLNetwork { get }

  /// Retrieve the XRP address associated with a PayID.
  ///
  /// - Note: Addresses are always in the X-Address format.
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Returns: A result with the given X-Address or an error.
  func xrpAddress(for payID: String) -> Result<Address, PayIDError>

  /// Retrieve the XRP address associated with a PayID.
  ///
  /// - Note: Addresses are always in the X-Address format.
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameters:
  ///   - payID: The payID to resolve for an address.
  ///   - callbackQueue: The queue to run a callback on.
  ///   - completion: A closure called with the result of the operation.
  /// - Returns: An address representing the given PayID.
  func xrpAddress(
    for payID: String,
    callbackQueue: DispatchQueue,
    completion: @escaping (Result<Address, PayIDError>) -> Void
  )
}
