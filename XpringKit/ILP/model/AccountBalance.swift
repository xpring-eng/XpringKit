/// Response object for requests to get an account's balance
public struct AccountBalance {

    /// The accountId for this account balance.
    public let accountID: AccountID

    /// Currency code or other asset identifier that this account's balances will be denominated in
    public let assetCode: String

    /// Interledger amounts are integers, but most currencies are typically represented as # fractional units, e.g. cents.
    /// This property defines how many Interledger units make # up one regular unit.
    /// For dollars, this would usually be set to 9, so that Interledger # amounts are expressed in nano-dollars.
    ///
    /// This is an Int32 representing this account's asset scale.
    public let assetScale: Int32

    /// The amount of units representing the clearing position this Connector operator holds with the account owner.
    /// A positive clearing balance indicates the Connector operator has an outstanding liability
    /// (i.e., owes money) to the account holder.
    /// A negative clearing balance represents an asset (i.e., the account holder owes money to the operator).
    ///
    /// A Int64 representing the net clearing balance of this account.
    public let clearingBalance: Int64

    /// The number of units that the account holder has prepaid. This value is factored into the value returned by
    /// netBalance(), and is generally never negative.
    ///
    /// A Int64 representing the number of units the counterparty (i.e., owner of this account) has
    /// prepaid with this Connector.
    public let prepaidAmount: Int64

    /// The amount of units representing the aggregate position this Connector operator holds
    /// with the account owner. A positive balance indicates the Connector operator has an outstanding
    /// liability (i.e., owes money) to the account holder.
    /// A negative balance represents an asset (i.e., the account holder owes money to the operator).
    /// This value is the sum of the clearing balance and the prepaid amount.
    ///
    /// A Int64 representing the net clearingBalance of this account.
    public let netBalance: Int64

    /// Private constructor to initialize an AccountBalance.
    /// Explicitly declare a constructor to derive netBalance
    private init(
        accountID: AccountID,
        assetCode: String,
        assetScale: Int32,
        clearingBalance: Int64,
        prepaidAmount: Int64
    ) {
        self.accountID = accountID
        self.assetCode = assetCode
        self.assetScale = assetScale
        self.clearingBalance = clearingBalance
        self.prepaidAmount = prepaidAmount
        self.netBalance = clearingBalance + prepaidAmount
    }

    /// Constructs an AccountBalance from a Org_Interledger_Stream_Proto_GetBalanceResponse
    ///
    /// - Parameters:
    ///     - getBalanceResponse: a GetBalanceResponse (protobuf object) whose field values will be used
    ///                           to construct an AccountBalance
    /// - Returns:an AccountBalance with its fields set via the analogous protobuf fields.
    public static func from(_ getBalanceResponse: Org_Interledger_Stream_Proto_GetBalanceResponse) -> AccountBalance {
        return AccountBalance(
            accountID: getBalanceResponse.accountID,
            assetCode: getBalanceResponse.assetCode,
            assetScale: getBalanceResponse.assetScale,
            clearingBalance: getBalanceResponse.clearingBalance,
            prepaidAmount: getBalanceResponse.prepaidAmount
        )
    }
}
