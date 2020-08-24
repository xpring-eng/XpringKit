import Foundation

/// Conforms to XRPCheckCash struct while providing an initializer that can construct an XRPCheckCash
/// from an Org_Xrpl_Rpc_V1_CheckCash
internal extension XRPCheckCash {

  /// Constructs an XRPCheckCash from an Org_Xrpl_Rpc_V1_CheckCash
  /// - SeeAlso: [CheckCash Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L132)
  ///
  /// - Parameters:
  ///     - checkCash: an Org_Xrpl_Rpc_V1_CheckCash (protobuf object) whose field values will be used to
  ///                  construct an XRPCheckCash
  /// - Returns: an XRPCheckCash with its fields set via the analogous protobuf fields.
  init?(checkCash: Org_Xrpl_Rpc_V1_CheckCash) {
    // checkId is required
    self.checkId = String(decoding: checkCash.checkID.value, as: UTF8.self)
    if self.checkId.isEmpty {
      return nil
    }

    // amount and deliverMin fields should be mutually exclusive
    switch checkCash.amountOneof {
    case .amount(let amount):
      self.amount = XRPCurrencyAmount(currencyAmount: amount.value)
      self.deliverMin = nil
    case .deliverMin(let deliverMin):
      self.deliverMin = XRPCurrencyAmount(currencyAmount: deliverMin.value)
      self.amount = nil
    case .none:
      return nil
    }
  }
}
