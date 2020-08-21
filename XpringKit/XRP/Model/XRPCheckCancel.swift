import Foundation

/// Represents a CheckCancel transaction on the XRP Ledger.
///
/// A CheckCancel transaction cancels an unredeemed Check, removing it from the ledger without sending any money.
/// The source or the destination of the check can cancel a Check at any time using this transaction type.
/// If the Check has expired, any address can cancel it.
///
/// - SeeAlso: https://xrpl.org/checkcancel.html
public struct XRPCheckCancel: Equatable {

  /// The ID of the Check ledger object to cancel, as a 64-character hexadecimal string.
  public let checkId: String
}
