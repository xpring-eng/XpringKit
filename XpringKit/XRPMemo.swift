import Foundation

/// Represents a memo on the XRPLedger.
/// - SeeAlso: https://xrpl.org/transaction-common-fields.html#memos-field
public struct XRPMemo: Equatable {

  /// Arbitrary hex value, conventionally containing the content of the memo.
  public let data: Data?

  /// Hex value representing characters allowed in URLs.
  /// Conventionally containing information on how the memo is encoded, for example as a MIME type.
  public let format: Data?

  /// Hex value representing characters allowed in URLs.
  /// Conventionally, a unique relation (according to RFC 5988) that defines the format of this memo.
  public let type: Data?
}
