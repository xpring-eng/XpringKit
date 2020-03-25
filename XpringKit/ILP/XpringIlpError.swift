/// Errors that may occur when interacting with Xpring's ILP infrastructure
public enum XpringIlpError: Error {

    /// The requested functionality is not yet implemented.
    case unimplemented

    /// The access token has an invalid format, likely starts with "Bearer "
    case invalidAccessToken
}
