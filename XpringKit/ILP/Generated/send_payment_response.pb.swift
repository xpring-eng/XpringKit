// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: send_payment_response.proto
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

/// Defines the fields that are returned after a SendPayment RPC has completed.
/// Next field: 4
public struct Org_Interledger_Stream_Proto_SendPaymentResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The original amount that was requested to be sent.
  public var originalAmount: UInt64 = 0

  /// The actual amount, in the receivers units, that was delivered to the receiver
  public var amountDelivered: UInt64 = 0

  /// The actual amount, in the senders units, that was sent to the receiver
  public var amountSent: UInt64 = 0

  /// Indicates if the payment was completed successfully.
  public var successfulPayment: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "org.interledger.stream.proto"

extension Org_Interledger_Stream_Proto_SendPaymentResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".SendPaymentResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "original_amount"),
    2: .standard(proto: "amount_delivered"),
    3: .standard(proto: "amount_sent"),
    4: .standard(proto: "successful_payment"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt64Field(value: &self.originalAmount)
      case 2: try decoder.decodeSingularUInt64Field(value: &self.amountDelivered)
      case 3: try decoder.decodeSingularUInt64Field(value: &self.amountSent)
      case 4: try decoder.decodeSingularBoolField(value: &self.successfulPayment)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.originalAmount != 0 {
      try visitor.visitSingularUInt64Field(value: self.originalAmount, fieldNumber: 1)
    }
    if self.amountDelivered != 0 {
      try visitor.visitSingularUInt64Field(value: self.amountDelivered, fieldNumber: 2)
    }
    if self.amountSent != 0 {
      try visitor.visitSingularUInt64Field(value: self.amountSent, fieldNumber: 3)
    }
    if self.successfulPayment != false {
      try visitor.visitSingularBoolField(value: self.successfulPayment, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Interledger_Stream_Proto_SendPaymentResponse, rhs: Org_Interledger_Stream_Proto_SendPaymentResponse) -> Bool {
    if lhs.originalAmount != rhs.originalAmount {return false}
    if lhs.amountDelivered != rhs.amountDelivered {return false}
    if lhs.amountSent != rhs.amountSent {return false}
    if lhs.successfulPayment != rhs.successfulPayment {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
