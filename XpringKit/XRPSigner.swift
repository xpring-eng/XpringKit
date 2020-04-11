import Foundation

/// Represents a signer of a transaction on the XRP Ledger.
/// - SeeAlso: https://xrpl.org/transaction-common-fields.html#signers-field
public struct XRPSigner: Equatable {
  
  /// The address associated with this signature, as it appears in the SignerList.
  public let account: Address
  
  /// The public key used to create this signature.
  public let signingPublicKey: Data
  
  /// A signature for this transaction, verifiable using the SigningPubKey.
  public let transactionSignature: Data
}
