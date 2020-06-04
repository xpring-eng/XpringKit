import SwiftGRPC
import SwiftProtobuf

/// A client which can make balance related calls to the ILP network
public protocol ILPNetworkBalanceClient {

  /// Retrieve the balance of an account.
  ///
  /// - Parameters:
  ///     - request: request parameters
  ///     - metadata: any request metadata, including authorization header
  /// - Throws: An error if there was a problem comunicating with the ILP network
  /// - Returns: A `GetBalanceResponse` with balance details for the requested account
  func getBalance(
    _ request: Org_Interledger_Stream_Proto_GetBalanceRequest,
    metadata customMetadata: Metadata
  ) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse
}

/// A client which can make balance related calls to the ILP network
@available(*, deprecated, message: "Please use the idiomatically named ILPNetworkBalanceClient class instead.")
public protocol IlpNetworkBalanceClient {

  /// Retrieve the balance of an account
  ///
  /// - Parameters:
  ///     - request: request parameters
  ///     - metadata: any request metadata, including authorization header
  /// - Throws: An error if there was a problem comunicating with the ILP network
  /// - Returns: A `GetBalanceResponse` with balance details for the requested account
  func getBalance(
    _ request: Org_Interledger_Stream_Proto_GetBalanceRequest,
    metadata customMetadata: Metadata
  ) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse
}
