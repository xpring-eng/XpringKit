import SwiftGRPC

/// A helper which provides a convenient way to initialize grpc.Metadata and
/// add an Authorization metadata header, and ensures every bearer token
/// going over the wire is prefixed with "Bearer "
internal class ILPCredentials {

  /// Unfortunately, Metadata is not an open class in SwiftGRPC, so we cannot extend it.
  /// Instead, it is wrapped in ILPCredentials
  private var metadata: Metadata

  private let bearerPrefix = "Bearer "

  /// Initialize a new ILPCredentials
  /// self.metadata will be initialized and an Authorization header will be added to it.  The value
  /// of that entry will be the bearerToken with "Bearer " prefix.
  ///
  /// - Parameters:
  ///     - accessToken: An access token with no "Bearer " prefix
  /// - Throws: if accessToken starts with "Bearer "
  public init(_ accessToken: String) throws {
    if accessToken.starts(with: bearerPrefix) {
      throw ILPError.invalidAccessToken
    }

    self.metadata = Metadata()
    try metadata.add(key: "authorization", value: bearerPrefix + accessToken)
  }

  /// Get the Metadata to pass to network calls
  public func getMetadata() -> Metadata {
    return self.metadata
  }
}

/// A helper which provides a convenient way to initialize grpc.Metadata and
/// add an Authorization metadata header, and ensures every bearer token
/// going over the wire is prefixed with "Bearer "
internal class IlpCredentials {

  /// Unfortunately, Metadata is not an open class in SwiftGRPC, so we cannot extend it.
  /// Instead, it is wrapped in IlpCredentials
  private var metadata: Metadata

  private let bearerPrefix = "Bearer "

  /// Initialize a new IlpCredentials
  /// self.metadata will be initialized and an Authorization header will be added to it.  The value
  /// of that entry will be the bearerToken with "Bearer " prefix.
  ///
  /// - Parameters:
  ///     - accessToken: An access token with no "Bearer " prefix
  /// - Throws: if accessToken starts with "Bearer "
  public init(_ accessToken: String) throws {
    if accessToken.starts(with: bearerPrefix) {
      throw IlpError.invalidAccessToken
    }

    self.metadata = Metadata()
    try metadata.add(key: "authorization", value: bearerPrefix + accessToken)
  }

  /// Get the Metadata to pass to network calls
  public func getMetadata() -> Metadata {
    return self.metadata
  }
}
