import Foundation

/// An interface for interaction with a PayID service.
public protocol PayIDClientProtocol {
  /// The network this PayID client resolves on.
  var network: XRPLNetwork { get }

  /// Resolve the given PayID to an XRP Address.
  ///
  /// - Note: The returned value will always be in an X-Address format.
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Parameter completion: A closure called with the result of the operation.
  /// - Returns: An XRP address representing the given PayID.
  // TODO(keefertaylor): Make this API synchronous to mirror functionality provided by ILP / XRP.
  func xrpAddress(for payID: String, completion: @escaping (Swift.Result<String, PayIDError>) -> Void)
}
