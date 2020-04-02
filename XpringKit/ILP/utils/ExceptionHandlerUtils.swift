import SwiftGRPC

/// Utility class for translating gRPC errors to native Xpring SDK errors.
public class ExceptionHandlerUtils {

    /// Handle an Error thrown from an Ilp network client call by translating it to
    /// a IlpError. gRPC services return an error with a status code,
    /// so we need to map gRPC error status to native IlpErrors.
    ///
    /// - Parameters:
    ///   - callResult: The CallResult of an RPCError returned by a network call.
    public static func handleIlpRPCErrorCallResult(_ callResult: CallResult) -> IlpError {
        switch callResult.statusCode {
        case .notFound:
            return IlpError.accountNotFound
        case .unauthenticated:
            return IlpError.unauthenticated
        case .invalidArgument:
            return IlpError.invalidArgument
        default:
            return IlpError.internalError
        }
    }
}
