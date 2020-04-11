import Foundation

/// An issued currency on the XRP Ledger
/// - SeeAlso: https://xrpl.org/currency-formats.html#currency-codes
public struct XRPCurrency: Equatable {
  
  /// The 3 character currency ASCII code.
  public let name: String
  
  /// The 160 bit currency code. 20 bytes.
  public let code: Data
}
