import XpringKit

extension Org_Interledger_Stream_Proto_GetBalanceResponse {
    static let testGetBalanceResponse = Org_Interledger_Stream_Proto_GetBalanceResponse.with {
        $0.accountID = "foo"
        $0.assetCode = "XRP"
        $0.assetScale = 9
        $0.clearingBalance = 100
        $0.prepaidAmount = 0
        $0.netBalance = 100
    }
}
