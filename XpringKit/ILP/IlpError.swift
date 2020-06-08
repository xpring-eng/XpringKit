import SwiftGRPC

/// Errors that may occur when interacting with Xpring's ILP infrastructure
public enum ILPError: Error {
  /// The accountID that was provided does not exist.
  case accountNotFound

  /// Something went wrong on the ILP network
  case internalError

  /// The access token has an invalid format, likely starts with "Bearer ".
  case invalidAccessToken

  /// The request had an invalid argument
  case invalidArgument

  /// Authentication failed on the requested connector.
  case unauthenticated

  /// The requested functionality is not yet implemented.
  case unimplemented

  /// An unknown error occurred
  case unknown

  /// Translate an Error thrown from an ILP network client to an ILPError.
  ///
  /// gRPC services return an error with a status code,
  /// so we need to map gRPC error status to native ILPErrors.
  ///
  /// - Parameters:
  ///   - callResult: The CallResult of an RPCError returned by a network call.
  public static func from(_ callResult: CallResult) -> ILPError {
    switch callResult.statusCode {
    case .notFound:
      return ILPError.accountNotFound
    case .unauthenticated:
      return ILPError.unauthenticated
    case .invalidArgument:
      return ILPError.invalidArgument
    case .internalError:
      return ILPError.internalError
    default:
      return ILPError.unknown
    }
  }
}

/// Errors that may occur when interacting with Xpring's ILP infrastructure
@available(*, deprecated, message: "Please use the idiomatically named ILPError enum instead.")
public enum IlpError: Error {
  /// The accountID that was provided does not exist.
  case accountNotFound

  /// Something went wrong on the ILP network
  case internalError

  /// The access token has an invalid format, likely starts with "Bearer ".
  case invalidAccessToken

  /// The request had an invalid argument
  case invalidArgument

  /// Authentication failed on the requested connector.
  case unauthenticated

  /// The requested functionality is not yet implemented.
  case unimplemented

  /// An unknown error occurred
  case unknown

  /// Translate an Error thrown from an Ilp network client to an IlpError.
  ///
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
    case .internalError:
      return IlpError.internalError
    default:
      return IlpError.unknown
    }
  }
}
