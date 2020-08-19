import Foundation

/// Conforms to XRPCheckCreate struct while providing an initializer that can construct an XRPCheckCreate
/// from an Org_Xrpl_Rpc_V1_CheckCreate
internal extension XRPCheckCreate {

  /// Constructs an XRPCheckCreate from an Org_Xrpl_Rpc_V1_CheckCreate
  /// - SeeAlso: [CheckCreate Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L145)
  ///
  /// - Parameters:
  ///     - checkCreate: an Org_Xrpl_Rpc_V1_CheckCreate (protobuf object) whose field values will be used to
  ///             construct an XRPCheckCreate
  /// - Returns: an XRPCheckCreate with its fields set via the analogous protobuf fields.
  init?(checkCreate: Org_Xrpl_Rpc_V1_CheckCreate, xrplNetwork: XRPLNetwork) {
    let destination = checkCreate.destination.value.address
    let destinationTag = checkCreate.destinationTag.value

    // must be successfully convertable to an X-Address
    guard let destinationXAddress = Utils.encode(
      classicAddress: destination,
      tag: destinationTag,
      isTest: xrplNetwork == XRPLNetwork.test || xrplNetwork == XRPLNetwork.dev
      ) else {
      return nil
    }
    self.destinationXAddress = destinationXAddress

    // sendMax is required
    let sendMaxCurrencyAmount = checkCreate.sendMax.value
    guard let sendMax = XRPCurrencyAmount(currencyAmount: sendMaxCurrencyAmount) else {
      return nil
    }
    self.sendMax = sendMax

    if checkCreate.hasExpiration {
      self.expiration = checkCreate.expiration.value
    } else {
      self.expiration = nil
    }
    if checkCreate.hasInvoiceID {
      self.invoiceId = String(decoding: checkCreate.invoiceID.value, as: UTF8.self)
    } else {
      self.invoiceId = nil
    }
  }
}
