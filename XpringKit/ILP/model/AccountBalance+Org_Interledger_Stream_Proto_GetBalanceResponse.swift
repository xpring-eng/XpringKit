/// Conforms to AccountBalance struct while providing an initializer that can construct an AccountBalance from a  Org_Interledger_Stream_Proto_GetBalanceResponse
extension AccountBalance {

    /// Constructs an AccountBalance from a Org_Interledger_Stream_Proto_GetBalanceResponse
    ///
    /// - Parameters:
    ///     - getBalanceResponse: a GetBalanceResponse (protobuf object) whose field values will be used
    ///                           to construct an AccountBalance
    /// - Returns: an AccountBalance with its fields set via the analogous protobuf fields.
    public init(getBalanceResponse: Org_Interledger_Stream_Proto_GetBalanceResponse) {
        self.init(
            accountID: getBalanceResponse.accountID,
            assetCode: getBalanceResponse.assetCode,
            assetScale: getBalanceResponse.assetScale,
            clearingBalance: getBalanceResponse.clearingBalance,
            prepaidAmount: getBalanceResponse.prepaidAmount,
            netBalance: getBalanceResponse.netBalance
        )
    }
}
