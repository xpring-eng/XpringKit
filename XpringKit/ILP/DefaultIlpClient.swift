import Foundation
import SwiftGRPC

/// Default client decorator for use in IlpClient
public class DefaultIlpClient: IlpClientDecorator {

    private let balanceNetworkClient: Org_Interledger_Stream_Proto_BalanceServiceServiceClient
    private let paymentNetworkClient: Org_Interledger_Stream_Proto_IlpOverHttpServiceServiceClient

    /// Initialize a new DefaultXpringClient
    ///
    /// - Parameters:
    ///     - grpcUrl: The gRPC URL exposed by Hermes
    public convenience init(grpcUrl: String) {
        let balanceNetworkClient =
            Org_Interledger_Stream_Proto_BalanceServiceServiceClient(address: grpcUrl, secure: false)
        let paymentNetworkClient =
            Org_Interledger_Stream_Proto_IlpOverHttpServiceServiceClient(address: grpcUrl, secure: false)
        self.init(balanceNetworkClient: balanceNetworkClient, paymentNetworkClient: paymentNetworkClient)
    }

    /// Initialize a new DefaultXpringClient
    ///
    /// - Parameters:
    ///     - balanceNetworkClient: gRPC generated client for balance operations
    ///     - paymentNetworkClient: gRPC generated client for payment operations
    internal init(balanceNetworkClient: Org_Interledger_Stream_Proto_BalanceServiceServiceClient,
                  paymentNetworkClient: Org_Interledger_Stream_Proto_IlpOverHttpServiceServiceClient) {
        self.balanceNetworkClient = balanceNetworkClient
        self.paymentNetworkClient = paymentNetworkClient
    }

    /// Get the balance of the specified account on the connector.
    ///
    /// - Parameters:
    ///     -  accountId The account ID to get the balance for.
    ///     -  bearerToken Authentication bearer token.
    /// - Returns: A Org_Interledger_Stream_Proto_GetBalanceResponse with balance information of the specified account
    /// - Throws: An error If the given inputs were invalid, the account doesn't exist, or authentication failed.
    public func getBalance(for accountId: String, bearerToken: String) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        throw XpringIlpError.unimplemented
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
        throw XpringIlpError.unimplemented
    }
}
