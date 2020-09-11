import Foundation

/// Represents a DepositPreauth transaction on the XRP Ledger.
///
/// A DepositPreauth transaction gives another account pre-approval to deliver payments to the sender
/// of this transaction.
/// This is only useful if the sender of this transaction is using (or plans to use) Deposit Authorization.
///
/// - SeeAlso: https://xrpl.org/depositpreauth.html
public struct XRPDepositPreauth: Equatable {
  /// Note: authorize and unauthorize are mutually exclusive fields: one but not both should be set.
  /// Addresses are encoded as X-addresses.
  /// - seeAlso: https://xrpaddress.info

  /// (Optional) The XRP Ledger address of the sender to preauthorize, encoded as an X-address.
  public let authorizeXAddress: String?

  /// (Optional) The XRP Ledger address of a sender whose preauthorization should be revoked,
  /// encoded as an X-address.
  public let unauthorizeXAddress: String?
}
