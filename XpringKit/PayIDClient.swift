import Foundation

/// A client for Xpring's PayID service.
///
/// Inputs to this class are always in X-Addresses
/// - SeeAlso: https://xrpaddress.info/
///
/// - Warning: This class is experimental and should not be used in production applications.
public class PayIDClient {
  /// The remote URL for the PayID service.
  private let remoteURL: URL

  /// An authorization token to use when performing updates to the PayID service.
  private let authorizationToken: String?

  /// Returns whether this client is authorized for update requests.
  public var isAuthorizedForUpdates: Bool {
    return authorizationToken != nil
  }

  /// Initialize a new unauthorized PayIDClient.
  ///
  /// - Parameters:
  ///   - remoteURL The remote URL of the service this class will communicate with.
  public convenience init(remoteURL: URL) {
    self.init(remoteURL: remoteURL, authorizationToken: nil)
  }

  /// Initialize a new unauthorized PayIDClient.
  ///
  /// - Parameters:
  ///   - remoteURL The remote URL of the service this class will communicate with.
  ///   - authorizationToken An optional token to authorize write requests. Defaults to undefined.
  public init(remoteURL: URL, authorizationToken: String? = nil) {
    self.remoteURL = remoteURL
    self.authorizationToken = authorizationToken
  }

  /// Retrieve the XRP Address authorized with a PayID.
  ///
  /// - Note: The returned value will always be in an X-Address format.
  ///
  /// - Parameter payID The payID to resolve for an address.
  /// - Returns: A resutl of the operation.
  public func address(for payID: String) -> Result<String, PayIDClientError> {
    // TODO(keefertaylor): Implement reads from backend service.
    return .failure(.unimplemented)
  }

  /// Update a PayID to XRP address mapping.
  ///
  /// - Note: The input address to this method must be in X-Address format.
  ///
  /// - Parameters:
  ///   - payID The payID to update.
  ///   - xrpAddress The new XRP address to associate with the payID.
  /// - Returns: A boolean indicating success of the operation.
  public func update(payID: String, to xrpAddress: String) -> Result<Bool, PayIDClientError> {
    // TODO(keefertaylor): Implement writes from backend service.
    return .failure(.unimplemented)
  }
}
