import Foundation

/// Represents an OfferCancel transaction on the XRP Ledger.
///
/// An OfferCancel transaction removes an Offer object from the XRP Ledger.
/// - SeeAlso: https://xrpl.org/offercancel.html
public struct XRPOfferCancel: Equatable {
  
  /// The sequence number of a previous OfferCreate transaction.
  /// If specified, cancel any offer object in the ledger that was created by that transaction.
  /// It is not considered an error if the offer specified does not exist.
  public let offerSequence: UInt32
}
