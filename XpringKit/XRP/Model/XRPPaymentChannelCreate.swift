import Foundation

/// Represents a PaymentChannelCreate transaction on the XRP Ledger.
///
/// A PaymentChannelCreate transaction creates a unidirectional channel and funds it with XRP.
/// The address sending this transaction becomes the "source address" of the payment channel.
/// - SeeAlso: https://xrpl.org/paymentchannelcreate.html
public struct XRPPaymentChannelCreate: Equatable {

  /// Amount of XRP, in drops, to deduct from the sender's balance and set aside in this channel.
  /// While the channel is open, the XRP can only go to the Destination address.
  /// When the channel closes, any unclaimed XRP is returned to the source address's balance.
  public let amount: XRPCurrencyAmount

  /// Address and (optional) destination tag to receive XRP claims against this channel,
  /// encoded as an X-address (see https://xrpaddress.info).
  /// This is also known as the "destination address" for the channel.
  /// Cannot be the same as the sender (Account).
  public let destinationXAddress: String

  /// Amount of time the source address must wait before closing the channel if it has unclaimed XRP.
  public let settleDelay: UInt32

  /// The public key of the key pair the source will use to sign claims against this channel, in hexadecimal.
  /// This can be any secp256k1 or Ed25519 public key.
  public let publicKey: String

  /// (Optional) The time, in seconds since the Ripple Epoch, when this channel expires.
  /// Any transaction that would modify the channel after this time closes the channel without otherwise affecting it.
  /// This value is immutable; the channel can be closed earlier than this time but cannot remain open after this time.
  public let cancelAfter: UInt32?
}
