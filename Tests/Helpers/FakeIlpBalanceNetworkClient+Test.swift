import SwiftGRPC
import XpringKit

extension FakeIlpBalanceNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .success(.testGetBalanceResponse))

    public static func withErrorResponse(_ errorResponse: Error) -> FakeIlpBalanceNetworkClient {
        return FakeIlpBalanceNetworkClient(getBalanceResult: .failure(errorResponse))
    }

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
