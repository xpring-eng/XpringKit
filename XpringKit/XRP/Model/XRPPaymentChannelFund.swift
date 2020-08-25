import Foundation

/// Represents a PaymentChannelFund transaction on the XRP Ledger.
///
/// A PaymentChannelFund transaction adds additional XRP to an open payment channel, updates the expiration
/// time of the channel, or both. Only the source address of the channel can use this transaction.
/// (Transactions from other addresses fail with the error tecNO_PERMISSION.)
/// - SeeAlso: https://xrpl.org/paymentchannelfund.html
public struct XRPPaymentChannelFund: Equatable {
  
  /// The unique ID of the channel to fund, as a 64-character hexadecimal string.
  public let channel: String
  
  /// Amount of XRP, in drops to add to the channel. To set the expiration for a channel without
  /// adding more XRP, set this to "0".
  public let amount: XRPCurrencyAmount
  
  /// (Optional) New Expiration time to set for the channel, in seconds since the Ripple Epoch.
  /// This must be later than either the current time plus the SettleDelay of the channel,
  /// or the existing Expiration of the channel. After the Expiration time, any transaction
  /// that would access the channel closes the channel without taking its normal action.
  /// Any unspent XRP is returned to the source address when the channel closes.
  /// (Expiration is separate from the channel's immutable CancelAfter time.)
  /// For more information, see the PayChannel ledger object type: https://xrpl.org/paychannel.html
  public let expiration: UInt32?
}
