import Foundation

/// Provides functionality for XRP in the PayID protocol.
public class XRPPayIDClient: PayIDClient, XRPPayIDClientProtocol {

  /// The XRP Ledger network that this client attaches to.
  var xrplNetwork: XRPLNetwork
  
  /// Initialize a new XRPPayIDclient
  ///
  /// - Parameter xrplNetwork: The XRP Ledger network that this client attaches to.
  public init(xrplNetwork: XRPLNetwork) {
    self.xrplNetwork = xrplNetwork
    super.init(network: "xrpl-\(xrplNetwork.rawValue)")
  }
  

  /// Retrieve the XRP address associated with a PayID.
  ///
  /// - Note: Addresses are always in the X-Address format.
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Returns: An address representing the given PayID.
  ///
  public func xrpAddress(for payID: String, completion: @escaping (String) -> Void) {
    super.address(for: payID) { result in
      switch result {
      case .success(let resolvedAddress):
        // here we make any necessary conversions
        completion(resolvedAddress.address)
      case .failure(let error):
        return
      }
    } // end closure
  }
}
