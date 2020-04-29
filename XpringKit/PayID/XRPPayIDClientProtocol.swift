import Foundation

/// A protocol for an XRP PayID client.
public protocol XRPPayIDClientProtocol {
  
  /// The XRP Ledger network that addresses will be resolved on.
  private let xrplNetwork: XRPLNetwork
  
  /// Resolve the given PayID to an XRP Address.
  ///
  /// - Note: The returned value will always be in an X-Address format.
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Returns: An XRP address representing the given PayID.
  // TODO(keefertaylor): Make this API synchronous to mirror functionality provided by ILP / XRP.
  func xrpAddress(for payID: String, completion: @escaping (Swift.Result<String, PayIDError>) -> Void)
}
