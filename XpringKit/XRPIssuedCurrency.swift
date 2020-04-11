import BigInt

/// A issued currency on the XRP Ledger
/// - SeeAlso: https://xrpl.org/basic-data-types.html#specifying-currency-amounts
public struct XRPIssuedCurrency: Equatable {
  
  /// The currency used to value the amount.
  public let currency: XRPCurrency
  
  /// The value of the amount.
  public let value: BigInt
  
  /// Unique account address of the entity issuing the currency.
  public let issuer: Address
}
