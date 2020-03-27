import SwiftGRPC

/// Utility class for translating gRPC errors to native Xpring SDK errors.
public class ExceptionHandlerUtils {

    /// Handle an Error thrown from an Ilp network client call by translating it to
    /// a XpringIlpError. gRPC services return an error with a status code,
    /// so we need to map gRPC error status to native XpringIlpErrors.
    ///
    /// - Parameters:
    ///   - callResult: The CallResult of an RPCError returned by a network call.
    public static func handleIlpRPCErrorCallResult(_ callResult: CallResult) -> XpringIlpError {
        switch callResult.statusCode {
        case .notFound:
            return XpringIlpError.accountNotFound
        case .unauthenticated:
            return XpringIlpError.unauthenticated
        case .invalidArgument:
            return XpringIlpError.invalidArgument
        default:
            return XpringIlpError.internalError
        }
    }
}
