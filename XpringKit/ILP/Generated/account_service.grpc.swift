//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: account_service.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Dispatch
import Foundation
import SwiftGRPC
import SwiftProtobuf

internal protocol Org_Interledger_Stream_Proto_AccountServiceGetAccountCall: ClientCallUnary {}

fileprivate final class Org_Interledger_Stream_Proto_AccountServiceGetAccountCallBase: ClientCallUnaryBase<Org_Interledger_Stream_Proto_GetAccountRequest, Org_Interledger_Stream_Proto_GetAccountResponse>, Org_Interledger_Stream_Proto_AccountServiceGetAccountCall {
  override class var method: String { return "/org.interledger.stream.proto.AccountService/GetAccount" }
}

internal protocol Org_Interledger_Stream_Proto_AccountServiceCreateAccountCall: ClientCallUnary {}

fileprivate final class Org_Interledger_Stream_Proto_AccountServiceCreateAccountCallBase: ClientCallUnaryBase<Org_Interledger_Stream_Proto_CreateAccountRequest, Org_Interledger_Stream_Proto_CreateAccountResponse>, Org_Interledger_Stream_Proto_AccountServiceCreateAccountCall {
  override class var method: String { return "/org.interledger.stream.proto.AccountService/CreateAccount" }
}

/// Instantiate Org_Interledger_Stream_Proto_AccountServiceServiceClient, then call methods of this protocol to make API calls.
internal protocol Org_Interledger_Stream_Proto_AccountServiceService: ServiceClient {
  /// Synchronous. Unary.
  func getAccount(_ request: Org_Interledger_Stream_Proto_GetAccountRequest, metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_GetAccountResponse
  /// Asynchronous. Unary.
  @discardableResult
  func getAccount(_ request: Org_Interledger_Stream_Proto_GetAccountRequest, metadata customMetadata: Metadata, completion: @escaping (Org_Interledger_Stream_Proto_GetAccountResponse?, CallResult) -> Void) throws -> Org_Interledger_Stream_Proto_AccountServiceGetAccountCall

  /// Synchronous. Unary.
  func createAccount(_ request: Org_Interledger_Stream_Proto_CreateAccountRequest, metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_CreateAccountResponse
  /// Asynchronous. Unary.
  @discardableResult
  func createAccount(_ request: Org_Interledger_Stream_Proto_CreateAccountRequest, metadata customMetadata: Metadata, completion: @escaping (Org_Interledger_Stream_Proto_CreateAccountResponse?, CallResult) -> Void) throws -> Org_Interledger_Stream_Proto_AccountServiceCreateAccountCall

}

internal extension Org_Interledger_Stream_Proto_AccountServiceService {
  /// Synchronous. Unary.
  func getAccount(_ request: Org_Interledger_Stream_Proto_GetAccountRequest) throws -> Org_Interledger_Stream_Proto_GetAccountResponse {
    return try self.getAccount(request, metadata: self.metadata)
  }
  /// Asynchronous. Unary.
  @discardableResult
  func getAccount(_ request: Org_Interledger_Stream_Proto_GetAccountRequest, completion: @escaping (Org_Interledger_Stream_Proto_GetAccountResponse?, CallResult) -> Void) throws -> Org_Interledger_Stream_Proto_AccountServiceGetAccountCall {
    return try self.getAccount(request, metadata: self.metadata, completion: completion)
  }

  /// Synchronous. Unary.
  func createAccount(_ request: Org_Interledger_Stream_Proto_CreateAccountRequest) throws -> Org_Interledger_Stream_Proto_CreateAccountResponse {
    return try self.createAccount(request, metadata: self.metadata)
  }
  /// Asynchronous. Unary.
  @discardableResult
  func createAccount(_ request: Org_Interledger_Stream_Proto_CreateAccountRequest, completion: @escaping (Org_Interledger_Stream_Proto_CreateAccountResponse?, CallResult) -> Void) throws -> Org_Interledger_Stream_Proto_AccountServiceCreateAccountCall {
    return try self.createAccount(request, metadata: self.metadata, completion: completion)
  }

}

internal final class Org_Interledger_Stream_Proto_AccountServiceServiceClient: ServiceClientBase, Org_Interledger_Stream_Proto_AccountServiceService {
  /// Synchronous. Unary.
  internal func getAccount(_ request: Org_Interledger_Stream_Proto_GetAccountRequest, metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_GetAccountResponse {
    return try Org_Interledger_Stream_Proto_AccountServiceGetAccountCallBase(channel)
      .run(request: request, metadata: customMetadata)
  }
  /// Asynchronous. Unary.
  @discardableResult
  internal func getAccount(_ request: Org_Interledger_Stream_Proto_GetAccountRequest, metadata customMetadata: Metadata, completion: @escaping (Org_Interledger_Stream_Proto_GetAccountResponse?, CallResult) -> Void) throws -> Org_Interledger_Stream_Proto_AccountServiceGetAccountCall {
    return try Org_Interledger_Stream_Proto_AccountServiceGetAccountCallBase(channel)
      .start(request: request, metadata: customMetadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func createAccount(_ request: Org_Interledger_Stream_Proto_CreateAccountRequest, metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_CreateAccountResponse {
    return try Org_Interledger_Stream_Proto_AccountServiceCreateAccountCallBase(channel)
      .run(request: request, metadata: customMetadata)
  }
  /// Asynchronous. Unary.
  @discardableResult
  internal func createAccount(_ request: Org_Interledger_Stream_Proto_CreateAccountRequest, metadata customMetadata: Metadata, completion: @escaping (Org_Interledger_Stream_Proto_CreateAccountResponse?, CallResult) -> Void) throws -> Org_Interledger_Stream_Proto_AccountServiceCreateAccountCall {
    return try Org_Interledger_Stream_Proto_AccountServiceCreateAccountCallBase(channel)
      .start(request: request, metadata: customMetadata, completion: completion)
  }

}

/// To build a server, implement a class that conforms to this protocol.
/// If one of the methods returning `ServerStatus?` returns nil,
/// it is expected that you have already returned a status to the client by means of `session.close`.
internal protocol Org_Interledger_Stream_Proto_AccountServiceProvider: ServiceProvider {
  func getAccount(request: Org_Interledger_Stream_Proto_GetAccountRequest, session: Org_Interledger_Stream_Proto_AccountServiceGetAccountSession) throws -> Org_Interledger_Stream_Proto_GetAccountResponse
  func createAccount(request: Org_Interledger_Stream_Proto_CreateAccountRequest, session: Org_Interledger_Stream_Proto_AccountServiceCreateAccountSession) throws -> Org_Interledger_Stream_Proto_CreateAccountResponse
}

extension Org_Interledger_Stream_Proto_AccountServiceProvider {
  internal var serviceName: String { return "org.interledger.stream.proto.AccountService" }

  /// Determines and calls the appropriate request handler, depending on the request's method.
  /// Throws `HandleMethodError.unknownMethod` for methods not handled by this service.
  internal func handleMethod(_ method: String, handler: Handler) throws -> ServerStatus? {
    switch method {
    case "/org.interledger.stream.proto.AccountService/GetAccount":
      return try Org_Interledger_Stream_Proto_AccountServiceGetAccountSessionBase(
        handler: handler,
        providerBlock: { try self.getAccount(request: $0, session: $1 as! Org_Interledger_Stream_Proto_AccountServiceGetAccountSessionBase) })
          .run()
    case "/org.interledger.stream.proto.AccountService/CreateAccount":
      return try Org_Interledger_Stream_Proto_AccountServiceCreateAccountSessionBase(
        handler: handler,
        providerBlock: { try self.createAccount(request: $0, session: $1 as! Org_Interledger_Stream_Proto_AccountServiceCreateAccountSessionBase) })
          .run()
    default:
      throw HandleMethodError.unknownMethod
    }
  }
}

internal protocol Org_Interledger_Stream_Proto_AccountServiceGetAccountSession: ServerSessionUnary {}

fileprivate final class Org_Interledger_Stream_Proto_AccountServiceGetAccountSessionBase: ServerSessionUnaryBase<Org_Interledger_Stream_Proto_GetAccountRequest, Org_Interledger_Stream_Proto_GetAccountResponse>, Org_Interledger_Stream_Proto_AccountServiceGetAccountSession {}

internal protocol Org_Interledger_Stream_Proto_AccountServiceCreateAccountSession: ServerSessionUnary {}

fileprivate final class Org_Interledger_Stream_Proto_AccountServiceCreateAccountSessionBase: ServerSessionUnaryBase<Org_Interledger_Stream_Proto_CreateAccountRequest, Org_Interledger_Stream_Proto_CreateAccountResponse>, Org_Interledger_Stream_Proto_AccountServiceCreateAccountSession {}