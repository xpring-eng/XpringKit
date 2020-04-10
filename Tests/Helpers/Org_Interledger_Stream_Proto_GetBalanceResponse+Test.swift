import XpringKit

extension Org_Interledger_Stream_Proto_GetBalanceResponse {
  static let testGetBalanceResponse = Org_Interledger_Stream_Proto_GetBalanceResponse.with {
    $0.accountID = .testAccountID
    $0.assetCode = .testAssetCode
    $0.assetScale = .testAssetScale
    $0.clearingBalance = .testIlpBalance
    $0.prepaidAmount = .testIlpBalance
    $0.netBalance = .testIlpBalance + .testIlpBalance
  }
}
