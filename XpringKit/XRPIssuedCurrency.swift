import BigInt

/// A issued currency on the XRP Ledger
/// - SeeAlso: https://xrpl.org/basic-data-types.html#specifying-currency-amounts
public struct XRPIssuedCurrency: Equatable {
  public let currency: XRPCurrency
  public let value: BigInt
  public let issuer: Address
}
