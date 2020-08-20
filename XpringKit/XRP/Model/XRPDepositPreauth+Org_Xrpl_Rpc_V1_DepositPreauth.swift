import Foundation

/// Conforms to XRPDepositPreauth struct while providing an initializer that can construct an XRPDepositPreauth
/// from an Org_Xrpl_Rpc_V1_DepositPreauth
internal extension XRPDepositPreauth {

  /// Constructs an XRPDepositPreauth from an Org_Xrpl_Rpc_V1_DepositPreauth
  /// - SeeAlso: [DepositPreauth Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/3d86b49dae8173344b39deb75e53170a9b6c5284/
  /// src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L159)
  ///
  /// - Parameters:
  ///     - depositPreauth: an Org_Xrpl_Rpc_V1_DepositPreauth (protobuf object) whose field values will be used to
  ///             construct an XRPDepositPreauth
  /// - Returns: an XRPDepositPreauth with its fields set via the analogous protobuf fields.
  init?(depositPreauth: Org_Xrpl_Rpc_V1_DepositPreauth, xrplNetwork: XRPLNetwork) {
    if let authorizeXAddress = Utils.encode(
      classicAddress: depositPreauth.authorize.value.address,
      isTest: xrplNetwork != XRPLNetwork.main
      ) {
      self.authorizeXAddress = authorizeXAddress
      self.unauthorizeXAddress = nil
      return
    }

    if let unauthorizeXAddress = Utils.encode(
      classicAddress: depositPreauth.unauthorize.value.address,
      isTest: xrplNetwork != XRPLNetwork.main
      ) {
      self.authorizeXAddress = nil
      self.unauthorizeXAddress = unauthorizeXAddress
    } else {
        return nil
      }
  }
}
