/// A path on the XRPLedger
/// - SeeAlso: https://xrpl.org/paths.html#path-specifications
public struct XRPPathElement: Equatable {
  public let account: Address?
  public let currency: XRPCurrency?
  public let issuer: Address?
}
