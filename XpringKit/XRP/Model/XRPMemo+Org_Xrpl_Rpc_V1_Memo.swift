/// Conforms to XRPMemo struct while providing an initializer that can construct an XRPMemo
/// from an Org_Xrpl_Rpc_V1_Memo
internal extension XRPMemo {

  /// Constructs an XRPMemo from an Org_Xrpl_Rpc_V1_Memo
  /// - SeeAlso: [Memo Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L80)
  ///
  /// - Parameters:
  ///     - memo: an Org_Xrpl_Rpc_V1_Memo (protobuf object) whose field values will be used
  ///             to construct an XRPMemo
  /// - Returns: an XRPMemo with its fields set via the analogous protobuf fields.
  init(memo: Org_Xrpl_Rpc_V1_Memo) {
    self.data = memo.hasMemoData ? memo.memoData.value : nil
    self.format = memo.hasMemoFormat ? memo.memoFormat.value : nil
    self.type = memo.hasMemoType ? memo.memoType.value : nil
  }
}
