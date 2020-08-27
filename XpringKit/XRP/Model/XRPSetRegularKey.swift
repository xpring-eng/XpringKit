import Foundation

/// Represents a SetRegularKey transaction on the XRP Ledger.
///
/// A SetRegularKey transaction assigns, changes, or removes the regular key pair associated with an account
/// You can protect your account by assigning a regular key pair to it and using it instead of the master key
/// pair to sign transactions whenever possible. If your regular key pair is compromised, but your master key
/// pair is not, you can use a SetRegularKey transaction to regain control of your account.
/// - SeeAlso: https://xrpl.org/setregularkey.html
public struct XRPSetRegularKey: Equatable {

  /// (Optional) A base-58-encoded Address that indicates the regular key pair to be assigned to the account.
  /// If omitted, removes any existing regular key pair from the account.
  /// Must not match the master key pair for the address.
  public let regularKey: String?
}
