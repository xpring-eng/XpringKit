import SwiftGRPC
import XpringKit

public class FakeIlpError {
    static let notFoundError = RPCError.callError(
        CallResult(
            success: false,
            statusCode: .notFound,
            statusMessage: "Mocked RPCError w/ notFound",
            resultData: nil,
            initialMetadata: nil,
            trailingMetadata: nil
        )
    )

    static let unauthenticatedError = RPCError.callError(
        CallResult(
            success: false,
            statusCode: .unauthenticated,
            statusMessage: "Mocked RPCError w/ notFound",
            resultData: nil,
            initialMetadata: nil,
            trailingMetadata: nil
        )
    )

    static let invalidArgumentError = RPCError.callError(
        CallResult(
            success: false,
            statusCode: .invalidArgument,
            statusMessage: "Mocked RPCError w/ notFound",
            resultData: nil,
            initialMetadata: nil,
            trailingMetadata: nil
        )
    )

    static let internalError = RPCError.callError(
        CallResult(
            success: false,
            statusCode: .internalError,
            statusMessage: "Mocked RPCError w/ notFound",
            resultData: nil,
            initialMetadata: nil,
            trailingMetadata: nil
        )
    )
}
