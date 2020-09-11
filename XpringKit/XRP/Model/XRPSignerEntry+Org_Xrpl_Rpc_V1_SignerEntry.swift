import Foundation

/// Conforms to XRPSignerEntry struct while providing an initializer that can construct
/// an XRPSignerEntry from an Org_Xrpl_Rpc_V1_SignerEntry
internal extension XRPSignerEntry {

  /// Constructs an XRPSignerEntry from an Org_Xrpl_Rpc_V1_SignerEntry
  /// - SeeAlso: [SignerEntry Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/f43aeda49c5362dc83c66507cae2ec71cfa7bfdf/
  /// src/ripple/proto/org/xrpl/rpc/v1/common.proto#L471)
  ///
  /// - Parameters:
  ///     - signerEntry: an Org_Xrpl_Rpc_V1_SignerEntry (protobuf object) whose
  ///                            field values will be used to construct an XRPSignerEntry
  /// - Returns: an XRPSignerEntry with its fields set via the analogous protobuf fields.
  init?(signerEntry: Org_Xrpl_Rpc_V1_SignerEntry) {
    // account and signerWeight are required
    if !signerEntry.hasAccount || !signerEntry.hasSignerWeight {
      return nil
    }

    self.account = signerEntry.account.value.address
    self.signerWeight = signerEntry.signerWeight.value
  }
}
