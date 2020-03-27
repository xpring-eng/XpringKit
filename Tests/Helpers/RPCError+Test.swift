import SwiftGRPC
import XpringKit

/// Wrapper class for fake RPCErrors
public class FakeIlpError {
    
    /// A fake RPCError with statusCode = StatusCode.notFound
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

    /// A fake RPCError with statusCode = StatusCode.unauthenticated
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

    /// A fake RPCError with statusCode = StatusCode.invalidArgument
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

    /// A fake RPCError with statusCode = StatusCode.internalError
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
