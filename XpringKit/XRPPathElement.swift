/// A path in the XRP Ledger.
/// - SeeAlso: https://xrpl.org/paths.html
public struct XRPPathElement: Equatable {
  public let account: Address?
  public let currency: XRPCurrency?
  public let issuer: Address?
}
