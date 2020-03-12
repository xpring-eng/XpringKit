import Foundation

/// Represents a signer of a transaction on the XRP Ledger.
/// - SeeAlso: https://xrpl.org/transaction-common-fields.html#signers-field
public struct XRPSigner: Equatable {
  public let account: Address
  public let signingPublicKey: Data
  public let transactionSignature: Data
}
