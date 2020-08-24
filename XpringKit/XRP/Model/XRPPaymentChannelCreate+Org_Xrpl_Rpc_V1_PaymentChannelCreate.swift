import Foundation

/// Conforms to XRPPaymentChannelCreate struct while providing an initializer that can construct
/// an XRPPaymentChannelCreate from an Org_Xrpl_Rpc_V1_PaymentChannelCreate
internal extension XRPPaymentChannelCreate {

  /// Constructs an XRPPaymentChannelCreate from an Org_Xrpl_Rpc_V1_PaymentChannelCreate
  /// - SeeAlso: [PaymentChannelCreate Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L272)
  ///
  /// - Parameters:
  ///     - paymentChannelCreate: an Org_Xrpl_Rpc_V1_PaymentChannelCreate (protobuf object) whose
  ///                            field values will be used to construct an XRPPaymentChannelCreate
  ///     - xrplNetwork: The XRPL network from which this object was retrieved.
  /// - Returns: an XRPPaymentChannelCreate with its fields set via the analogous protobuf fields.
  init?(paymentChannelCreate: Org_Xrpl_Rpc_V1_PaymentChannelCreate, xrplNetwork: XRPLNetwork) {
    if let amount = XRPCurrencyAmount(currencyAmount: paymentChannelCreate.amount.value) {
      self.amount = amount
    } else {
      return nil
    }

    if let destinationXAddress = Utils.encode(
      classicAddress: paymentChannelCreate.destination.value.address,
      tag: paymentChannelCreate.destinationTag.value,
      isTest: xrplNetwork != XRPLNetwork.main
      ) {
      self.destinationXAddress = destinationXAddress
    } else {
      return nil
    }

    if paymentChannelCreate.hasSettleDelay {
      self.settleDelay = paymentChannelCreate.settleDelay.value
    } else {
      return nil
    }

    if paymentChannelCreate.hasPublicKey {
      self.publicKey = String(decoding: paymentChannelCreate.publicKey.value, as: UTF8.self)
    } else {
      return nil
    }

    self.cancelAfter = paymentChannelCreate.hasCancelAfter
      ? paymentChannelCreate.cancelAfter.value
      : nil
  }
}
