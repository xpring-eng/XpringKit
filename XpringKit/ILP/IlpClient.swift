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
    /// - Returns: An AccountBalance with balance information of the specified account
    /// - Throws: An error If the given inputs were invalid, the account doesn't exist, or authentication failed.
    public func getBalance(for accountID: AccountID,
                           withAuthorization bearerToken: BearerToken
    ) throws -> AccountBalance {
        return try decoratedClient.getBalance(for: accountID, withAuthorization: bearerToken)
    }

    /// Send a payment from the given accountID to the destinationPaymentPointer payment pointer
    ///
    /// - Note: This method will not necessarily throw an exception if the payment failed.
    ///         Payment status can be checked in PaymentResult.successfulPayment
    /// - Parameters:
    ///     -  paymentRequest: A PaymentRequest with options for a payment
    ///     -  bearerToken : auth token of the sender
    /// - Returns: A PaymentResult with details about the payment.
    /// - Throws: An error If the given inputs were invalid.
    public func sendPayment(_ paymentRequest: PaymentRequest,
                            withAuthorization bearerToken: BearerToken
    ) throws -> PaymentResult {
        return try decoratedClient.sendPayment(
            paymentRequest,
            withAuthorization: bearerToken
        )
    }
}
