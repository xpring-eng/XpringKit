import SwiftGRPC

/// A helper which provides a convenient way to initialize grpc.Metadata and
/// add an Authorization metadata header, and ensures every bearer token
/// going over the wire is prefixed with "Bearer "
class IlpCredentials {

    /// Unfortunately, Metadata is not an open class in SwiftGRPC, so we cannot extend it.
    /// Instead, it is wrapped in IlpCredentials
    private var metadata: Metadata

    /// Initialize a new IlpCredentials
    /// self.metadata will be initialized and an Authorization header will be added to it.  The value
    /// of that entry will be the bearerToken with "Bearer " prefix.
    public init(_ bearerToken: String) throws {
        self.metadata = Metadata()
        try metadata.add(key: "Authorization", value: self.applyBearer(bearerToken))
    }

    /// Prepends 'Bearer ' to an auth token, if it is not already prefixed with "Bearer "
    ///
    /// - Parameters:
    ///     - token: An auth token that either does or does not have a "Bearer " prefix
    /// - Returns: A bearer token as a String, with a "Bearer " prefix
    private func applyBearer(_ token: String) -> String {
        return token.starts(with: "Bearer ") ? token : "Bearer " + token
    }

    /// Get the Metadata to pass to network calls
    public func get() -> Metadata {
        return self.metadata
    }
}
