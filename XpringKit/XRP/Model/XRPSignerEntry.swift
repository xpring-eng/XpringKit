import Foundation

/// Represents a SignerEntry object on the XRP Ledger.
/// - seeAlso: https://xrpl.org/signerlist.html#signerentry-object
public struct XRPSignerEntry: Equatable {

  /// An XRP Ledger address whose signature contributes to the multi-signature.
  /// It does not need to be a funded address in the ledger.
  public let account: String

  /// The weight of a signature from this signer. A multi-signature is only valid if the sum
  /// weight of the signatures provided meets or exceeds the SignerList's SignerQuorum value.
  public let signerWeight: UInt32
}
