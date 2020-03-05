/// A client that can get balances and send ILP payments on a Xpring connector.
public class IlpClient {

    private let decoratedClient: IlpClientDecorator

    /// Initialize a new client with a configured URL
    ///
    /// - Parameters:
    ///     - grpcUrl : The gRPC URL exposed by Hermes
    public init(grpcUrl: String) {
        decoratedClient = DefaultIlpClient(grpcUrl: grpcUrl)
    }

    /// Get the balance of the specified account on the connector.
    ///
    /// - Parameters:
    ///     -  accountId The account ID to get the balance for.
    ///     -  bearerToken Authentication bearer token.
    /// - Returns: A Org_Interledger_Stream_Proto_GetBalanceResponse with balance information of the specified account
    /// - Throws: An error If the given inputs were invalid, the account doesn't exist, or authentication failed.
    public func getBalance(for accountId: String, bearerToken: String) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        return try decoratedClient.getBalance(for: accountId, bearerToken: bearerToken)
    }

    /// Send a payment from the given accountId to the destinationPaymentPointer payment pointer
    /// - Parameters:
    ///     -  amount : Amount to send
    ///     -  paymentPointer : payment pointer of the receiver
    ///     -  senderAccountId : accountId of the sender
    ///     -  bearerToken : auth token of the sender
    /// - Returns: A Org_Interledger_Stream_Proto_SendPaymentResponse with details about the payment. Note that this method will not
    ///          necessarily throw an exception if the payment failed. Payment status can be checked in
    ///          {@link SendPaymentResponse#getSuccessfulPayment()}
    /// - Throws: An error If the given inputs were invalid.
    public func sendPayment(amount: UInt64,
                            paymentPointer: String,
                            senderAccountId: String,
                            bearerToken: String) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse {
        return try decoratedClient.sendPayment(amount: amount,
                                           paymentPointer: paymentPointer,
                                           senderAccountId: senderAccountId,
                                           bearerToken: bearerToken)
    }
}
