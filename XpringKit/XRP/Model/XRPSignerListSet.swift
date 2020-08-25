import Foundation

/// Represents a SignerListSet transaction on the XRP Ledger.
///
/// A SignerListSet transaction creates, replaces, or removes a list of signers that can be used to multi-sign a
/// transaction. This transaction type was introduced by the MultiSign amendment.
/// - seeAlso: https://xrpl.org/signerlistset.html
public struct XRPSignerListSet: Equatable {

  /// A target number for the signer weights. A multi-signature from this list is valid only if the sum weights
  /// of the signatures provided is greater than or equal to this value. To delete a SignerList, use the value 0.
  public let signerQuorum: UInt32

  /// (Omitted when deleting) Array of XRPSignerEntry objects, indicating the addresses and weights of signers in this list.
  /// A SignerList must have at least 1 member and no more than 8 members.
  /// No address may appear more than once in the list, nor may the Account submitting the transaction appear in the list.
  public let signerEntries: [XRPSignerEntry]?
}
