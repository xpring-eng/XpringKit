import Foundation

/// Conforms to XRPPayment struct while providing an initializer that can construct
/// an XRPPayment from an Org_Xrpl_Rpc_V1_Payment
internal extension XRPPayment {

  /// Constructs an XRPPayment from an Org_Xrpl_Rpc_V1_Payment
  /// - SeeAlso: [Payment Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L224)
  ///
  /// - Parameters:
  ///     - payment: an Org_Xrpl_Rpc_V1_Payment (protobuf object) whose field values will
  ///                be used to construct an XRPPayment
  ///     - xrplNetwork: The XRPL network from which this object was retrieved.
  /// - Returns: an XRPPayment with its fields set via the analogous protobuf fields.
  init?(payment: Org_Xrpl_Rpc_V1_Payment, xrplNetwork: XRPLNetwork) {
    guard let amount = XRPCurrencyAmount(currencyAmount: payment.amount.value) else {
      return nil
    }
    self.amount = amount
    let destination = payment.destination.value.address
    let destinationTag = payment.hasDestinationTag ? payment.destinationTag.value : nil
    self.destinationXAddress = Utils.encode(
      classicAddress: destination,
      tag: destinationTag,
      isTest: xrplNetwork == XRPLNetwork.test
    )

    // If the deliverMin field is set, it must be able to be transformed into a XRPCurrencyAmount.
    if payment.hasDeliverMin {
      if let deliverMin = XRPCurrencyAmount(currencyAmount: payment.deliverMin.value) {
        self.deliverMin = deliverMin
      } else {
        return nil
      }
    } else {
      self.deliverMin = nil
    }

    self.invoiceID = payment.hasInvoiceID ? payment.invoiceID.value : nil
    self.paths = !payment.paths.isEmpty ? payment.paths.map { path in XRPPath(path: path) } : nil

    // If the sendMax field is set, it must be able to be transformed into a XRPCurrencyAmount.
    if payment.hasSendMax {
      if let sendMax = XRPCurrencyAmount(currencyAmount: payment.sendMax.value) {
        self.sendMax = sendMax
      } else {
        return nil
      }
    } else {
      self.sendMax = nil
    }
  }
}
