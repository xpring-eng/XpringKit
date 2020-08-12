import Foundation

/// Represents an AccountSet transaction on the XRP Ledger.
/// An AccountSet transaction modifies the properties of an account in the XRP Ledger.
/// - SeeAlso: https://xrpl.org/accountset.html
public struct XRPAccountSet: Equatable {

  /// (Optional) Unique identifier of a flag to disable for this account.
  public let clearFlag: UInt32?

  /// (Optional) The domain that owns this account, as a string of hex representing the
  /// ASCII for the domain in lowercase.
  public let domain: String?

  /// (Optional) Hash of an email address to be used for generating an avatar image.
  public let emailHash: Data?

  /// (Optional) Public key for sending encrypted messages to this account.
  public let messageKey: Data?

  /// (Optional) Integer flag to enable for this account.
  public let setFlag: UInt32?

  /// (Optional) The fee to charge when users transfer this account's issued currencies,
  /// represented as billionths of a unit. Cannot be more than 2000000000 or less than
  /// 1000000000, except for the special case 0 meaning no fee.
  public let transferRate: UInt32?

  /// (Optional) Tick size to use for offers involving a currency issued by this address.
  /// The exchange rates of those offers is rounded to this many significant digits.
  /// Valid values are 3 to 15 inclusive, or 0 to disable. (Requires the TickSize amendment.)
  public let tickSize: UInt32?
}
