import Foundation

/// Conforms to XRPPaymentChannelClaim struct while providing an initializer that can construct
/// an XRPPaymentChannelClaim from an Org_Xrpl_Rpc_V1_PaymentChannelClaim
internal extension XRPPaymentChannelClaim {

  /// Constructs an XRPPaymentChannelClaim from an Org_Xrpl_Rpc_V1_PaymentChannelClaim
  /// - SeeAlso: [PaymentChannelClaim Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L258)
  ///
  /// - Parameters:
  ///     - paymentChannelClaim: an Org_Xrpl_Rpc_V1_PaymentChannelClaim (protobuf object) whose
  ///                            field values will be used to construct an XRPPaymentChannelClaim
  /// - Returns: an XRPPaymentChannelClaim with its fields set via the analogous protobuf fields.
  init?(paymentChannelClaim: Org_Xrpl_Rpc_V1_PaymentChannelClaim) {
    guard paymentChannelClaim.hasChannel else {
      return nil
    }
    self.channel = String(
      decoding: paymentChannelClaim.channel.value,
      as: UTF8.self
    )

    if paymentChannelClaim.hasBalance {
      guard let balance = XRPCurrencyAmount(currencyAmount: paymentChannelClaim.balance.value) else {
        // if balance is explicitly set, it must be convertable to an XRPCurrencyAmount
        return nil
      }
      self.balance = balance

    } else {
      self.balance = nil
    }

    if paymentChannelClaim.hasAmount {
      guard let amount = XRPCurrencyAmount(currencyAmount: paymentChannelClaim.amount.value) else {
        // if amount is explicitly set, it must be convertable to an XRPCurrencyAmount
        return nil
      }
      self.amount = amount
    } else {
      self.amount = nil
    }

    self.signature = paymentChannelClaim.hasPaymentChannelSignature
      ? String(decoding: paymentChannelClaim.paymentChannelSignature.value, as: UTF8.self)
      : nil

    self.publicKey = paymentChannelClaim.hasPublicKey
      ? String(decoding: paymentChannelClaim.publicKey.value, as: UTF8.self)
      : nil
  }
}
