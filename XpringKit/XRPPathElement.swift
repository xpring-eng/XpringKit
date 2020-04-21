/// A path on the XRPLedger
/// - SeeAlso: https://xrpl.org/paths.html#path-specifications
public struct XRPPathElement: Equatable {

  /// (Optional) If present, this path step represents rippling through the specified address.
  /// MUST NOT be provided if this path element specifies the currency or issuer fields.
  public let account: Address?

  /// (Optional) If present, this path element represents changing currencies through an order book.
  /// The currency specified indicates the new currency. MUST NOT be provided if this path
  /// element specifies the account field.
  public let currency: XRPCurrency?

  /// (Optional) If present, this path element represents changing currencies and this address defines the issuer of
  /// the new currency. If omitted in a path element with a non-XRP currency, a previous element of the path defines the
  /// issuer. If present when currency is omitted, indicates a path element that uses an order book between same-named
  /// currencies with different issuers.
  /// MUST be omitted if the currency is XRP. MUST NOT be provided if this element specifies the account field.
  public let issuer: Address?
}
