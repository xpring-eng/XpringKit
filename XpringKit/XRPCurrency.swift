import Foundation

/// An issued currency on the XRP Ledger
/// - SeeAlso: 
public struct XRPCurrency: Equatable {
  public let name: String
  public let code: Data
}
