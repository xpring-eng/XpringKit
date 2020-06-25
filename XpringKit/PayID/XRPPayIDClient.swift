import Foundation

/// Provides functionality for XRP in the PayID protocol.
public class XRPPayIDClient: PayIDClient, XRPPayIDClientProtocol {

  /// The XRP Ledger network that this client attaches to.
  public let xrplNetwork: XRPLNetwork

  /// Initialize a new XRPPayIDClient
  ///
  /// - Parameter xrplNetwork: The XRP Ledger network that this client attaches to.
  public init(xrplNetwork: XRPLNetwork) {
    self.xrplNetwork = xrplNetwork
    super.init()
  }

  /// Retrieve the XRP address associated with a PayID.
  ///
  /// - Note: Addresses are always in the X-Address format.
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameter payID: The payID to resolve for an address.
  /// - Parameter completion: A closure called with the result of the operation.
  /// - Returns: An address representing the given PayID.
  public func xrpAddress(for payID: String, completion: @escaping (Result<String, PayIDError>) -> Void) {
    let network = "xrpl-\(self.xrplNetwork.rawValue)"
    super.cryptoAddress(for: payID, on: network) { [weak self] result in
      guard let self = self else {
        return
      }

      switch result {
      case .success(let resolvedAddress):
        do {
          let encodedXAddress = try self.toXAddress(cryptoAddressDetails: resolvedAddress)
          completion(.success(encodedXAddress))
        } catch PayIDError.unexpectedResponse {
          completion(.failure(PayIDError.unexpectedResponse))
        } catch {
          completion(.failure(PayIDError.unknown(error: "Unknown error occurred while converting to XAddress.")))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  internal func toXAddress(cryptoAddressDetails: CryptoAddressDetails) throws -> String {
    if Utils.isValidXAddress(address: cryptoAddressDetails.address) {
      return cryptoAddressDetails.address
    }
    let isTest = self.xrplNetwork != XRPLNetwork.main
    if let rawTag = cryptoAddressDetails.tag {
      let tag = UInt32(rawTag)
      guard let encodedXAddress = Utils.encode(classicAddress: cryptoAddressDetails.address, tag: tag, isTest: isTest)
        else {
          throw PayIDError.unexpectedResponse
        }
      return encodedXAddress
    } else { // There is no tag
      guard let encodedXAddress = Utils.encode(classicAddress: cryptoAddressDetails.address, isTest: isTest)
      else {
        throw PayIDError.unexpectedResponse
      }
    return encodedXAddress
    }
  }
}
