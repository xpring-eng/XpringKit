import Foundation

/// Conforms to XRPEscrowCreate struct while providing an initializer that can construct an XRPEscrowCreate
/// from an Org_Xrpl_Rpc_V1_EscrowCreate
internal extension XRPEscrowCreate {

  /// Constructs an XRPEscrowCreate from an Org_Xrpl_Rpc_V1_EscrowCreate
  /// - SeeAlso: [EscrowCreate Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L178)
  ///
  /// - Parameters:
  ///     - escrowCreate: an Org_Xrpl_Rpc_V1_EscrowCreate (protobuf object) whose field values will be used to
  ///             construct an XRPEscrowCreate
  ///     - xrplNetwork: the XRPLNetwork from which this object was retrieved.
  /// - Returns: an XRPEscrowCreate with its fields set via the analogous protobuf fields.
  init?(escrowCreate: Org_Xrpl_Rpc_V1_EscrowCreate, xrplNetwork: XRPLNetwork) {
    // amount is a required field
    let currencyAmount = escrowCreate.amount.value
    if let xrpCurrencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmount) {
      self.amount = xrpCurrencyAmount
    } else {
      return nil
    }

    let destination = escrowCreate.destination.value.address
    let destinationTag = escrowCreate.destinationTag.value
    if let destinationXAddress = Utils.encode(
      classicAddress: destination,
      tag: destinationTag,
      isTest: xrplNetwork != XRPLNetwork.main
      ) {
      self.destinationXAddress = destinationXAddress
    } else {
      return nil
    }
    
    self.cancelAfter = escrowCreate.hasCancelAfter ? escrowCreate.cancelAfter.value : nil
    self.finishAfter = escrowCreate.hasFinishAfter ? escrowCreate.finishAfter.value : nil
    self.condition = escrowCreate.hasCondition
      ? String(decoding: escrowCreate.condition.value, as: UTF8.self)
      : nil
  }
}
