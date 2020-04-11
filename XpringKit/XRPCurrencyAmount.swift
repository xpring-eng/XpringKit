/// An amount of currency on the XRP Ledger
/// - SeeAlso: https://xrpl.org/basic-data-types.html#specifying-currency-amounts
public struct XRPCurrencyAmount: Equatable {
  /// Mutually exclusive, only one of the below fields is set.
  
  /// An amount of XRP, specified in drops.
  public let drops: UInt64?
  
  /// An amount of an issued currency.
  public let issuedCurrency: XRPIssuedCurrency?
}
