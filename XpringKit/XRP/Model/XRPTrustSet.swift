import Foundation

/// Represents a TrustSet transaction on the XRP Ledger.
///
/// A TrustSet transaction creates or modifies a trust line linking two accounts.
/// - seeAlso: https://xrpl.org/trustset.html
public struct XRPTrustSet: Equatable {
  
  /// Object defining the trust line to create or modify, in the format of an XRPCurrencyAmount.
  /// limitAmount.currency: The currency this trust line applies to, as a three-letter ISO 4217 Currency Code,
  /// or a 160-bit hex value according to currency format. "XRP" is invalid.
  /// limitAmount.value: Quoted decimal representation of the limit to set on this trust line.
  /// limitAmount.issuer: The address of the account to extend trust to.
  public let limitAmount: XRPCurrencyAmount
  
  /// (Optional) Value incoming balances on this trust line at the ratio of this number per 1,000,000,000 units.
  /// A value of 0 is shorthand for treating balances at face value.
  public let qualityIn: UInt32?
  
  /// (Optional) Value outgoing balances on this trust line at the ratio of this number per 1,000,000,000 units.
  /// A value of 0 is shorthand for treating balances at face value.
  public let qualityOut: UInt32?
}

