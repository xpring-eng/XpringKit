import XpringKit

extension Org_Xrpl_Rpc_V1_Amount {
  public static let testAmountXrpDrops = Org_Xrpl_Rpc_V1_Amount.with {
    $0.value = .testCurrencyAmountXrpDrops
  }

  public static let testAmountIssuedCurrencyAmount = Org_Xrpl_Rpc_V1_Amount.with {
    $0.value = .testCurrencyAmountIssuedCurrency
  }
}
