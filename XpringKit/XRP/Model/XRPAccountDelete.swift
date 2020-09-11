import Foundation

/// Represents an AccountDelete transaction on the XRP Ledger.
/// An AccountDelete transaction deletes an account and any objects it owns in the XRP Ledger,
/// - SeeAlso: https://xrpl.org/accountdelete.html
public struct XRPAccountDelete: Equatable {
  /// The address and destination tag of an account to receive any leftover XRP after deleting the
  /// sending account, encoded as an X-address (see https://xrpaddress.info/).
  /// Must be a funded account in the ledger, and must not be the sending account.
  public let destinationXAddress: Address
}
