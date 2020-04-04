import SwiftGRPC
import XpringKit

extension FakeIlpPaymentNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .success(.testSendPaymentResponse))

    /// Creates a FakeIlpPaymentNetworkClient which will always throw the specified Error
    ///
    /// - Parameters:
    ///     - errorResponse: An Error that will be thrown by the network client
    public static func with(errorResponse: Error) -> FakeIlpPaymentNetworkClient {
        return FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(errorResponse))
    }

    /// Creates a FakeIlpPaymentNetworkClient which will always return an RPCError with callError of the specified status code
    ///
    /// - Parameters:
    ///     - statusCode: The grpc status code of the RPCError returned by the network client
    public static func with(statusCode: StatusCode) -> FakeIlpPaymentNetworkClient {
        let rpcError = RPCError.callError(
            CallResult(
                success: false,
                statusCode: statusCode,
                statusMessage: "Mocked RPCError",
                resultData: nil,
                initialMetadata: nil,
                trailingMetadata: nil
            )
        )

        return FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(rpcError))
    }
}
