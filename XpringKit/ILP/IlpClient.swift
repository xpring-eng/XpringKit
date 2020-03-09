/// A client that can get balances and send ILP payments on a Xpring connector.
public class IlpClient {

    private let decoratedClient: IlpClientDecorator

    /// Initialize a new client with a configured URL
    ///
    /// - Parameters:
    ///     - grpcURL : The gRPC URL exposed by Hermes
    public init(grpcURL: String) {
        decoratedClient = DefaultIlpClient(grpcURL: grpcURL)
    }

    /// Get the balance of the specified account on the connector.
    ///
    /// - Parameters:
    ///     -  accountID The account ID to get the balance for.
    ///     -  bearerToken Authentication bearer token.
    /// - Returns: A Org_Interledger_Stream_Proto_GetBalanceResponse with balance information of the specified account
    /// - Throws: An error If the given inputs were invalid, the account doesn't exist, or authentication failed.
    public func getBalance(for accountID: AccountID,
                           withAuthorization bearerToken: BearerToken
    ) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        return try decoratedClient.getBalance(for: accountID, withAuthorization: bearerToken)
    }

    /// Send a payment from the given accountID to the destinationPaymentPointer payment pointer
    ///
    /// - Note: This method will not necessarily throw an exception if the payment failed.
    ///         Payment status can be checked in SendPaymentResponse#getSuccessfulPayment()
    /// - Parameters:
    ///     -  amount : Amount to send
    ///     -  paymentPointer : payment pointer of the receiver
    ///     -  senderAccountId : accountID of the sender
    ///     -  bearerToken : auth token of the sender
    /// - Returns: A Org_Interledger_Stream_Proto_SendPaymentResponse with details about the payment.
    /// - Throws: An error If the given inputs were invalid.
    public func sendPayment(_ amount: UInt64,
                            to destinationPaymentPointer: PaymentPointer,
                            from senderAccountId: AccountID,
                            withAuthorization bearerToken: BearerToken
    ) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse {
        return try decoratedClient.sendPayment(
            amount,
            to: destinationPaymentPointer,
            from: senderAccountId,
            withAuthorization: bearerToken
        )
    }
}
