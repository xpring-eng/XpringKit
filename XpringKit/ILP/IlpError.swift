import SwiftGRPC

/// Errors that may occur when interacting with Xpring's ILP infrastructure
public enum IlpError: Error {

    /// The requested functionality is not yet implemented.
    case unimplemented

    /// The access token has an invalid format, likely starts with "Bearer ".
    case invalidAccessToken

    /// The accountID that was provided does not exist.
    case accountNotFound

    /// Authentication failed on the requested connector.
    case unauthenticated

    /// The request had an invalid argument
    case invalidArgument

    /// Something went wrong on the ILP network
    case internalError

    /// Handle an Error thrown from an Ilp network client call by translating it to an IlpError.
    /// gRPC services return an error with a status code,
    /// so we need to map gRPC error status to native IlpErrors.
    ///
    /// - Parameters:
    ///   - callResult: The CallResult of an RPCError returned by a network call.
    public static func from(_ callResult: CallResult) -> IlpError {
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
