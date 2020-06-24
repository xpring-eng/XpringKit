import Foundation

/// Provides functionality for XRP in the PayID protocol.
public class XRPPayIDClient: PayIDClient, XRPPayIDClientProtocol {

  /// The XRP Ledger network that this client attaches to.
  public let xrplNetwork: XRPLNetwork

  /// A queue to perform async operations on.
  private let asyncQueue = DispatchQueue(label: "io.xpring.XRPPayIDClient", qos: .userInitiated)

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
  /// - Returns: A result with the given X-Address or an error.
  public func xrpAddress(for payID: String) -> Result<Address, PayIDError> {
    let result = super.address(for: payID)
    switch result {
    case .success(let resolvedAddress):
      do {
        let encodedXAddress = try self.toXAddress(cryptoAddressDetails: resolvedAddress)
        return .success(encodedXAddress)
      } catch PayIDError.unexpectedResponse {
        return .failure(PayIDError.unexpectedResponse)
      } catch {
        let error = PayIDError.unknown(error: "Unknown error occurred while converting to XAddress.")
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }

  /// Retrieve the XRP address associated with a PayID.
  ///
  /// - Note: Addresses are always in the X-Address format.
  /// - SeeAlso: https://xrpaddress.info/
  ///
  /// - Parameters:
  ///   - payID: The payID to resolve for an address.
  ///   - callbackQueue: The queue to run a callback on. Defaults to the main thread.
  ///   - completion: A closure called with the result of the operation.
  /// - Returns: An address representing the given PayID.
  public func xrpAddress(
    for payID: String,
    callbackQueue: DispatchQueue = .main,
    completion: @escaping (Result<Address, PayIDError>) -> Void
  ) {
    let queueSafeCompletion: (Result<Address, PayIDError>) -> Void = { result in
      callbackQueue.async {
        completion(result)
      }
    }

    asyncQueue.async {
      let result = self.xrpAddress(for: payID)
      queueSafeCompletion(result)
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
