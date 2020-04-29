import Foundation

/// Provides functionality for XRP in the PayID protocol.
public class XRPPayIDClient: PayIDClient {
  
  /// The XRP Ledger network that this client attaches to.
  var xrplNetwork: XRPLNetwork
  
  /// Initialize a new XRPPayIDclient
  ///
  /// - Parameter xrplNetwork: The XRP Ledger network that this client attaches to.
  init(xrplNetwork: XRPLNetwork) {
    super.init(network: "xrpl-\(xrplNetwork)")
    self.xrplNetwork = xrplNetwork
  }
}
