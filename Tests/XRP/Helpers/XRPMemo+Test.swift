@testable import XpringKit

extension XRPMemo {
  static let iForgotToPickUpCarlMemo = XRPMemo.fromMemoFields(
    data: .memoField1,
    format: .memoField2,
    type: .memoField3
  )

  // Exists because ledger will store empty values as blank.
  static let expectedNoDataMemo = XRPMemo.fromMemoFields(
    data: nil,
    format: .memoField2,
    type: .memoField3
  )

  static let expectedNoFormatMemo = XRPMemo.fromMemoFields(
    data: .memoField1,
    format: nil,
    type: .memoField3
  )

  static let expectedNoTypeMemo = XRPMemo.fromMemoFields(
    data: .memoField1,
    format: .memoField2,
    type: nil
  )
}
