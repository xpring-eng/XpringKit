import Foundation

/// Represents a PaymentChannelClaim transaction on the XRP Ledger.
///
/// A PaymentChannelClaim transaction claims XRP from a payment channel,
/// adjusts the payment channel's expiration, or both.
/// - SeeAlso: https://xrpl.org/paymentchannelclaim.html
public struct XRPPaymentChannelClaim: Equatable {

  /// The unique ID of the channel, as a 64-character hexadecimal string.
  public let channel: String

  /// (Optional) Total amount of XRP, in drops, delivered by this channel after processing this claim.
  /// Required to deliver XRP. Must be more than the total amount delivered by the channel so far,
  /// but not greater than the Amount of the signed claim. Must be provided except when closing the channel.
  public let balance: XRPCurrencyAmount?

  /// (Optional) The amount of XRP, in drops, authorized by the Signature.
  /// This must match the amount in the signed message.
  /// This is the cumulative amount of XRP that can be dispensed by the channel, including XRP previously redeemed.
  public let amount: XRPCurrencyAmount?

  /// (Optional) The signature of this claim, as hexadecimal. The signed message contains the channel ID and the
  /// amount of the claim. Required unless the sender of the transaction is the source address of the channel.
  public let signature: String?

  /// (Optional) The public key used for the signature, as hexadecimal. This must match the PublicKey stored
  /// in the ledger for the channel. Required unless the sender of the transaction is the source address of
  /// the channel and the Signature field is omitted. (The transaction includes the PubKey so that rippled
  /// can check the validity of the signature before trying to apply the transaction to the ledger.)
  public let publicKey: String?
}
