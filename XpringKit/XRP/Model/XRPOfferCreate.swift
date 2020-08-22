import Foundation

/// Represents an OfferCreate transaction on the XRP Ledger.
///
/// An OfferCreate transaction is effectively a limit order.
/// It defines an intent to exchange currencies, and creates
/// an Offer object if not completely fulfilled when placed.
/// Offers can be partially fulfilled.
///
/// - SeeAlso: https://xrpl.org/offercreate.html
public struct XRPOfferCreate: Equatable {
  
  /// The amount and type of currency being provided by the offer creator.
  public let takerGets: XRPCurrencyAmount
  
  /// The amount and type of currency being requested by the offer creator.
  public let takerPays: XRPCurrencyAmount
  
  /// (Optional) Time after which the offer is no longer active, in seconds since the Ripple Epoch.
  public let expiration: UInt32?
  
  /// (Optional) An offer to delete first, specified in the same way as OfferCancel.
  public let offerSequence: UInt32?
}
