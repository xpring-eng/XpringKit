import SwiftGRPC
import XpringKit

extension FakeIlpBalanceNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .success(.testGetBalanceResponse))

    /// Creates a FakeIlpBalanceNetworkClient which will always throw the specified Error
    ///
    /// - Parameters:
    ///     - errorResponse: An Error that will be thrown by the network client
    public static func withErrorResponse(_ errorResponse: Error) -> FakeIlpBalanceNetworkClient {
        return FakeIlpBalanceNetworkClient(getBalanceResult: .failure(errorResponse))
    }

    /// Creates a FakeIlpBalanceNetworkClient which will always return an RPCError with callError of the specified status code
    ///
    /// - Parameters:
    ///     - statusCode: The grpc status code of the RPCError returned by the network client
    public static func withErrorResponse(_ statusCode: StatusCode) -> FakeIlpBalanceNetworkClient {
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

        return FakeIlpBalanceNetworkClient(getBalanceResult: .failure(rpcError))
    }
}
