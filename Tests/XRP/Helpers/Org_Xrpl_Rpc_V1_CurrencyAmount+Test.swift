import XpringKit

extension Org_Xrpl_Rpc_V1_CurrencyAmount {
  public static let testCurrencyAmountXrpDrops = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
    $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
      $0.drops = .testDropsAmount
    }
  }

  public static let testCurrencyAmountIssuedCurrency = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
    $0.issuedCurrencyAmount = .testIssuedCurrencyAmount
  }
}
