// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: transaction_status.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// The status of a transaction on the XRP Ledger.
/// Next field: 4
public struct Io_Xpring_TransactionStatus {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The transaction status code.
  public var transactionStatusCode: String = String()

  /// Whether the transaction was validated.
  public var validated: Bool = false

  /// The lastLedgerSequence this transaction will be valid in.
  public var lastLedgerSequence: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "io.xpring"

extension Io_Xpring_TransactionStatus: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TransactionStatus"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "transaction_status_code"),
    2: .same(proto: "validated"),
    3: .standard(proto: "last_ledger_sequence"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.transactionStatusCode)
      case 2: try decoder.decodeSingularBoolField(value: &self.validated)
      case 3: try decoder.decodeSingularUInt32Field(value: &self.lastLedgerSequence)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.transactionStatusCode.isEmpty {
      try visitor.visitSingularStringField(value: self.transactionStatusCode, fieldNumber: 1)
    }
    if self.validated != false {
      try visitor.visitSingularBoolField(value: self.validated, fieldNumber: 2)
    }
    if self.lastLedgerSequence != 0 {
      try visitor.visitSingularUInt32Field(value: self.lastLedgerSequence, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Io_Xpring_TransactionStatus, rhs: Io_Xpring_TransactionStatus) -> Bool {
    if lhs.transactionStatusCode != rhs.transactionStatusCode {return false}
    if lhs.validated != rhs.validated {return false}
    if lhs.lastLedgerSequence != rhs.lastLedgerSequence {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
