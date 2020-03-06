import Foundation
import SwiftGRPC

/// Default client decorator for use in IlpClient
public class DefaultIlpClient {

    private let balanceNetworkClient: IlpNetworkBalanceClient
    private let paymentNetworkClient: IlpNetworkPaymentClient

    /// Initialize a new DefaultXpringClient
    ///
    /// - Parameters:
    ///     - grpcURL: The gRPC URL exposed by Hermes
    public convenience init(grpcURL: String) {
        let balanceNetworkClient =
            Org_Interledger_Stream_Proto_BalanceServiceServiceClient(address: grpcURL, secure: false)
        let paymentNetworkClient =
            Org_Interledger_Stream_Proto_IlpOverHttpServiceServiceClient(address: grpcURL, secure: false)
        self.init(balanceNetworkClient: balanceNetworkClient, paymentNetworkClient: paymentNetworkClient)
    }

    /// Initialize a new DefaultXpringClient
    ///
    /// - Parameters:
    ///     - balanceNetworkClient: gRPC generated client for balance operations
    ///     - paymentNetworkClient: gRPC generated client for payment operations
    internal init(balanceNetworkClient: IlpNetworkBalanceClient,
                  paymentNetworkClient: IlpNetworkPaymentClient) {
        self.balanceNetworkClient = balanceNetworkClient
        self.paymentNetworkClient = paymentNetworkClient
    }
}

extension DefaultIlpClient: IlpClientDecorator {
    /// Get the balance of the specified account on the connector.
    ///
    /// - Parameters:
    ///     -  accountID The account ID to get the balance for.
    ///     -  bearerToken Authentication bearer token.
    /// - Returns: A Org_Interledger_Stream_Proto_GetBalanceResponse with balance information of the specified account
    /// - Throws: An error If the given inputs were invalid, the account doesn't exist, or authentication failed.
    public func getBalance(for accountID: String,
                           withAuthorization bearerToken: String
    ) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        throw XpringIlpError.unimplemented
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
    /// - Returns: A Org_Interledger_Stream_Proto_SendPaymentResponse with details about the payment
    /// - Throws: An error If the given inputs were invalid.
    public func sendPayment(_ amount: UInt64,
                            to paymentPointer: String,
                            from senderAccountId: String,
                            withAuthorization bearerToken: String
    ) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse {
        throw XpringIlpError.unimplemented
    }
}
