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
}
