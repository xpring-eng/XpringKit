import Foundation

/// A protocol for an XRP PayID client.
public protocol XRPPayIDClientProtocol {
  /// The network that addresses will be resolved on.
  var xrplNetwork: XRPLNetwork { get set }
  
  /// Retrieve the XRP address associated with a PayID.
  ///
  /// - Note: Addresses are always in the X-Address format.
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Returns: An address representing the given PayID.
  ///
  // TODO(keefertaylor): Make this API synchronous to mirror functionality provided by ILP / XRP.
  func xrpAddress(for payID: String, completion: @escaping (Result<String, PayIDError>) -> Void)
}
