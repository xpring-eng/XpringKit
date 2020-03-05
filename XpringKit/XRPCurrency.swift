import Foundation

/// An issued currency on the XRP Ledger
/// - SeeAlso: https://xrpl.org/currency-formats.html#currency-codes
public struct XRPCurrency: Equatable {
  public let name: String
  public let code: Data
}
