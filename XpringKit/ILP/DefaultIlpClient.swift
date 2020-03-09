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
            Org_Interledger_Stream_Proto_BalanceServiceServiceClient(address: grpcURL)
        let paymentNetworkClient =
            Org_Interledger_Stream_Proto_IlpOverHttpServiceServiceClient(address: grpcURL)
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
    public func getBalance(for accountID: AccountID,
                           withAuthorization bearerToken: BearerToken
    ) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        let balanceRequest = Org_Interledger_Stream_Proto_GetBalanceRequest.with {
            $0.accountID = accountID
        }
        let metaData = Metadata()
        try metaData.add(key: "authorization", value: bearerToken)
        return try self.balanceNetworkClient.getBalance(balanceRequest, metadata: metaData)
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
                            to paymentPointer: PaymentPointer,
                            from senderAccountId: AccountID,
                            withAuthorization bearerToken: BearerToken
    ) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse {
        let paymentRequest = Org_Interledger_Stream_Proto_SendPaymentRequest.with {
            $0.amount = amount
            $0.destinationPaymentPointer = paymentPointer
            $0.accountID = senderAccountId
        }

        let metaData = Metadata()
        try metaData.add(key: "authorization", value: bearerToken)
        return try self.paymentNetworkClient.sendMoney(paymentRequest, metadata: metaData)
    }
}
