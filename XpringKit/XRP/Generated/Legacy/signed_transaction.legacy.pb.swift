// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: signed_transaction.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
private struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// A transaction and associated signature data.
/// Next field: 3
public struct Io_Xpring_SignedTransaction {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The underlying transaction associated with the signature.
  public var transaction: Io_Xpring_Transaction {
    get { return _transaction ?? Io_Xpring_Transaction() }
    set { _transaction = newValue }
  }
  /// Returns true if `transaction` has been explicitly set.
  public var hasTransaction: Bool { return self._transaction != nil }
  /// Clears the value of `transaction`. Subsequent reads from it will return its default value.
  public mutating func clearTransaction() { self._transaction = nil }

  /// The signature of the transaction in hexadecimal.
  public var transactionSignatureHex: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _transaction: Io_Xpring_Transaction?
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

private let _protobuf_package = "io.xpring"

extension Io_Xpring_SignedTransaction: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".SignedTransaction"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "transaction"),
    2: .standard(proto: "transaction_signature_hex")
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._transaction)
      case 2: try decoder.decodeSingularStringField(value: &self.transactionSignatureHex)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._transaction {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.transactionSignatureHex.isEmpty {
      try visitor.visitSingularStringField(value: self.transactionSignatureHex, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Io_Xpring_SignedTransaction, rhs: Io_Xpring_SignedTransaction) -> Bool {
    if lhs._transaction != rhs._transaction { return false }
    if lhs.transactionSignatureHex != rhs.transactionSignatureHex { return false }
    if lhs.unknownFields != rhs.unknownFields { return false }
    return true
  }
}
