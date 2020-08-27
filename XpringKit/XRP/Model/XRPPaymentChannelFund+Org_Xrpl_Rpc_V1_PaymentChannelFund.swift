import Foundation

/// Conforms to XRPPaymentChannelFund struct while providing an initializer that can construct
/// an XRPPaymentChannelFund from an Org_Xrpl_Rpc_V1_PaymentChannelFund
internal extension XRPPaymentChannelFund {

  /// Constructs an XRPPaymentChannelFund from an Org_Xrpl_Rpc_V1_PaymentChannelFund
  /// - SeeAlso: [PaymentChannelFund Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L288)
  ///
  /// - Parameters:
  ///     - paymentChannelFund: an Org_Xrpl_Rpc_V1_PaymentChannelFund (protobuf object) whose
  ///                            field values will be used to construct an XRPPaymentChannelFund
  /// - Returns: an XRPPaymentChannelFund with its fields set via the analogous protobuf fields.
  init?(paymentChannelFund: Org_Xrpl_Rpc_V1_PaymentChannelFund) {
    if paymentChannelFund.hasChannel {
      self.channel = String(decoding: paymentChannelFund.channel.value, as: UTF8.self)
    } else {
      return nil
    }

    if paymentChannelFund.hasAmount {
      if let amount = XRPCurrencyAmount(currencyAmount: paymentChannelFund.amount.value) {
        self.amount = amount
      } else {
        return nil
      }
    } else {
      return nil
    }

    self.expiration = paymentChannelFund.hasExpiration
      ? paymentChannelFund.expiration.value
      : nil
  }
}
