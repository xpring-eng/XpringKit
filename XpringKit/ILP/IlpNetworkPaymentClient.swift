import SwiftGRPC
import SwiftProtobuf

// A client that can make payment related requests to the ILP network
public protocol IlpNetworkPaymentClient {

    /// Send a payment over ILP
    ///
    /// - Parameters:
    ///     - request: request parameters
    ///     - metadata: any request metadata, including authorization header
    /// - Throws: An error if there was a problem communicating with the ILP network
    /// - Returns: A `SendPaymentResponse` with details about the requested payment
    func sendMoney(_ request: Org_Interledger_Stream_Proto_SendPaymentRequest,
                   metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse
}
