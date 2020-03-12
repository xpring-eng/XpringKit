import Foundation

internal extension XRPPayment {
  init?(payment: Org_Xrpl_Rpc_V1_Payment) {
    guard let amount = XRPCurrencyAmount(currencyAmount: payment.amount.value) else {
      return nil
    }
    self.amount = amount
    self.destination = payment.destination.value.address
    self.destinationTag = payment.hasDestinationTag ? payment.destinationTag.value : nil

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
    self.paths = payment.paths.count > 0 ? payment.paths.map { path in XRPPath(path: path) } : nil

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
