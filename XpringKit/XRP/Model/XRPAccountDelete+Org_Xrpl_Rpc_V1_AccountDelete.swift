import Foundation

/// Conforms to XRPAccountDelete struct while providing an initializer that can construct an XRPAccountDelete
/// from an Org_Xrpl_Rpc_V1_AccountDelete
internal extension XRPAccountDelete {

  /// Constructs an XRPAccountDelete from an Org_Xrpl_Rpc_V1_AccountDelete
  /// - SeeAlso: [AccountDelete Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L118)
  ///
  /// - Parameters:
  ///     - accountDelete: an Org_Xrpl_Rpc_V1_AccountDelete (protobuf object) whose field values will be used to
  ///             construct an XRPAccountDelete
  ///     - xrplNetwork: The XRPL network from which this object was retrieved.
  /// - Returns: an XRPAccountDelete with its fields set via the analogous protobuf fields.
  init?(accountDelete: Org_Xrpl_Rpc_V1_AccountDelete, xrplNetwork: XRPLNetwork) {
    let destination = accountDelete.destination.value.address
    let destinationTag = accountDelete.destinationTag.value

    guard let destinationXAddress = Utils.encode(
      classicAddress: destination,
      tag: destinationTag,
      isTest: xrplNetwork.isTest
      ) else {
        return nil
    }
    self.destinationXAddress = destinationXAddress
  }
}
