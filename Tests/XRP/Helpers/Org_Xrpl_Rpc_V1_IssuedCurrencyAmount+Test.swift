import XpringKit

extension Org_Xrpl_Rpc_V1_IssuedCurrencyAmount {
  public static let testIssuedCurrencyAmount = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {
    $0.currency = .testCurrency
    $0.value = "15"
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = .testClassicAddress
    }
  }
}
