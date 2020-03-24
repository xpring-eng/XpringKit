import Foundation
import SwiftGRPC

/// Default client decorator for use in IlpClient
public class DefaultIlpClient {

    private let balanceNetworkClient: IlpNetworkBalanceClient
    private let paymentNetworkClient: IlpNetworkPaymentClient

    /// Initialize a new DefaultILPClient
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

    /// Initialize a new DefaultILPClient
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
    ///     -  accessToken Authentication access token. Can not start with "Bearer "
    /// - Returns: An AccountBalance with balance information of the specified account
    /// - Throws: An error If the given inputs were invalid, the account doesn't exist, or authentication failed.
    public func getBalance(for accountID: AccountID,
                           withAuthorization accessToken: AccessToken
    ) throws -> AccountBalance {
        let balanceRequest = Org_Interledger_Stream_Proto_GetBalanceRequest.with {
            $0.accountID = accountID
        }
        let getBalanceResponse = try self.balanceNetworkClient.getBalance(
            balanceRequest,
            metadata: IlpCredentials(accessToken).getMetadata()
        )
        return AccountBalance(getBalanceResponse: getBalanceResponse)
    }

    /// Send a payment from the given accountID to the destinationPaymentPointer payment pointer
    ///
    /// - Note: This method will not necessarily throw an exception if the payment failed.
    ///         Payment status can be checked in PaymentResult.successfulPayment
    /// - Parameters:
    ///     -  paymentRequest: A PaymentRequest with options for a payment
    ///     -  accessToken : access token of the sender. Can not start with "Bearer "
    /// - Returns: A PaymentResult with details about the payment.
    /// - Throws: An error If the given inputs were invalid.
    public func sendPayment(_ paymentRequest: PaymentRequest,
                            withAuthorization accessToken: AccessToken
    ) throws -> PaymentResult {
        let paymentRequest = paymentRequest.toProto()
        let paymentResponse = try self.paymentNetworkClient.sendMoney(
            paymentRequest,
            metadata: IlpCredentials(accessToken).getMetadata()
        )
        return PaymentResult(sendPaymentResponse: paymentResponse)
    }
}
