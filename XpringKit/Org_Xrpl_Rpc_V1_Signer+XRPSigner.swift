/// Conforms to XRPSigner struct while providing an initializer that can construct an XRPSigner
/// from an Org_Xrpl_Rpc_V1_Signer
internal extension XRPSigner {

  /// Constructs an XRPSigner from an Org_Xrpl_Rpc_V1_Signer
  /// - SeeAlso: [Signer Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L90)
  ///
  /// - Parameters:
  ///     - signer: a Org_Xrpl_Rpc_V1_Signer (protobuf object) whose field values will be used to
  ///                 construct an XRPSigner
  /// - Returns: an XRPSigner with its fields set via the analogous protobuf fields.
  init(signer: Org_Xrpl_Rpc_V1_Signer) {
    self.account = signer.account.value.address
    self.signingPublicKey = signer.signingPublicKey.value
    self.transactionSignature = signer.transactionSignature.value
  }
}
