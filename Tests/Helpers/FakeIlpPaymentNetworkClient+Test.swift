import SwiftGRPC
import XpringKit

extension FakeIlpPaymentNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .success(.testSendPaymentResponse))

    public static func withErrorResponse(_ errorResponse: Error) -> FakeIlpPaymentNetworkClient {
        return FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(errorResponse))
    }

    public static func withErrorResponse(_ statusCode: StatusCode) -> FakeIlpPaymentNetworkClient {
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
