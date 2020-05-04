import Foundation

/// Provides functionality for XRP in the PayID protocol.
public class XRPPayIDClient: PayIDClient, XRPPayIDClientProtocol {

  /// The XRP Ledger network that this client attaches to.
  public var xrplNetwork: XRPLNetwork

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
  public func xrpAddress(for payID: String, completion: @escaping (Result<String, PayIDError>) -> Void) {
    super.address(for: payID) { [weak self] result in
      guard let self = self else {
        return
      }

      switch result {
      case .success(let resolvedAddress):
        if Utils.isValid(address: resolvedAddress.address) {
          completion(.success(resolvedAddress.address))
        }

        let isTest = self.xrplNetwork != XRPLNetwork.main
        let tag = UInt32(resolvedAddress.tag ?? "")
        let encodedXAddress = Utils.encode(classicAddress: resolvedAddress.address, tag: tag, isTest: isTest)
        if encodedXAddress == nil {
          let unexpectedError = PayIDError.unexpectedResponse
          completion(.failure(unexpectedError))
        }
        completion(.success(encodedXAddress!))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
