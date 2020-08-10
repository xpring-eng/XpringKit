import Foundation

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
    let data = memo.hasMemoData ? memo.memoData.value : nil
    let format = memo.hasMemoFormat ? memo.memoFormat.value : nil
    let type = memo.hasMemoType ? memo.memoType.value : nil

    self.init(data: data, format: format, type: type)
  }

  /// Constructs an XRPMemo from strings that may or may not be hex-encoded (as indicated by the MemoField argument)
  ///
  /// - Parameters:
  ///  - data: an optional MemoField containing a string which may or may not be converted to a hex string.
  ///  - format:  an optional MemoField with a string which may or may not be converted to a hex string.
  ///  - type:  an optional MemoField with a string which may or may not be converted to a hex string.
  /// - Returns: an XRPMemo with each potentially hex-encoded field set to the Data version of said field.
  func fromMemoFields(data: MemoField?, format: MemoField?, type: MemoField?) -> XRPMemo {
    var dataBytes: Data?
    var formatBytes: Data?
    var typeBytes: Data?

    if let unwrappedData = data {
      dataBytes = unwrappedData.isHex
        ? try? Data(unwrappedData.value.toBytes())
        : unwrappedData.value.data(using: .utf8)
    }

    if let unwrappedFormat = format {
      formatBytes = unwrappedFormat.isHex
        ? try? Data(unwrappedFormat.value.toBytes())
        : unwrappedFormat.value.data(using: .utf8)
    }

    if let unwrappedType = type {
      typeBytes = unwrappedType.isHex
        ? try? Data(unwrappedType.value.toBytes())
        : unwrappedType.value.data(using: .utf8)
    }

    return XRPMemo(
      data: dataBytes,
      format: formatBytes,
      type: typeBytes
    )
  }
}
