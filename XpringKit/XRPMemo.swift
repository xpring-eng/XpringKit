import Foundation

/// Represents a memo on the XRPLedger.
/// - SeeAlso: https://xrpl.org/transaction-common-fields.html#memos-field
public struct XRPMemo: Equatable {
  public let data: Data?
  public let format: Data?
  public let type: Data?
}
