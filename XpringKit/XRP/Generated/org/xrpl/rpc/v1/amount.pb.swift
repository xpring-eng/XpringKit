// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: org/xrpl/rpc/v1/amount.proto
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
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// Next field: 3
public struct Org_Xrpl_Rpc_V1_CurrencyAmount {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var amount: Org_Xrpl_Rpc_V1_CurrencyAmount.OneOf_Amount? = nil

  public var xrpAmount: Org_Xrpl_Rpc_V1_XRPDropsAmount {
    get {
      if case .xrpAmount(let v)? = amount {return v}
      return Org_Xrpl_Rpc_V1_XRPDropsAmount()
    }
    set {amount = .xrpAmount(newValue)}
  }

  public var issuedCurrencyAmount: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount {
    get {
      if case .issuedCurrencyAmount(let v)? = amount {return v}
      return Org_Xrpl_Rpc_V1_IssuedCurrencyAmount()
    }
    set {amount = .issuedCurrencyAmount(newValue)}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public enum OneOf_Amount: Equatable {
    case xrpAmount(Org_Xrpl_Rpc_V1_XRPDropsAmount)
    case issuedCurrencyAmount(Org_Xrpl_Rpc_V1_IssuedCurrencyAmount)

  #if !swift(>=4.1)
    public static func ==(lhs: Org_Xrpl_Rpc_V1_CurrencyAmount.OneOf_Amount, rhs: Org_Xrpl_Rpc_V1_CurrencyAmount.OneOf_Amount) -> Bool {
      switch (lhs, rhs) {
      case (.xrpAmount(let l), .xrpAmount(let r)): return l == r
      case (.issuedCurrencyAmount(let l), .issuedCurrencyAmount(let r)): return l == r
      default: return false
      }
    }
  #endif
  }

  public init() {}
}

/// A representation of an amount of XRP.
/// Next field: 2
public struct Org_Xrpl_Rpc_V1_XRPDropsAmount {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var drops: UInt64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// A representation of an amount of issued currency.
/// Next field: 4
public struct Org_Xrpl_Rpc_V1_IssuedCurrencyAmount {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The currency used to value the amount.
  public var currency: Org_Xrpl_Rpc_V1_Currency {
    get {return _currency ?? Org_Xrpl_Rpc_V1_Currency()}
    set {_currency = newValue}
  }
  /// Returns true if `currency` has been explicitly set.
  public var hasCurrency: Bool {return self._currency != nil}
  /// Clears the value of `currency`. Subsequent reads from it will return its default value.
  public mutating func clearCurrency() {self._currency = nil}

  /// The value of the amount. 8 bytes
  public var value: String = String()

  /// Unique account address of the entity issuing the currency.
  public var issuer: Org_Xrpl_Rpc_V1_AccountAddress {
    get {return _issuer ?? Org_Xrpl_Rpc_V1_AccountAddress()}
    set {_issuer = newValue}
  }
  /// Returns true if `issuer` has been explicitly set.
  public var hasIssuer: Bool {return self._issuer != nil}
  /// Clears the value of `issuer`. Subsequent reads from it will return its default value.
  public mutating func clearIssuer() {self._issuer = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _currency: Org_Xrpl_Rpc_V1_Currency? = nil
  fileprivate var _issuer: Org_Xrpl_Rpc_V1_AccountAddress? = nil
}

/// Next field: 3
public struct Org_Xrpl_Rpc_V1_Currency {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// 3 character ASCII code
  public var name: String = String()

  /// 160 bit currency code. 20 bytes
  public var code: Data = SwiftProtobuf.Internal.emptyData

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "org.xrpl.rpc.v1"

extension Org_Xrpl_Rpc_V1_CurrencyAmount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".CurrencyAmount"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "xrp_amount"),
    2: .standard(proto: "issued_currency_amount"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        var v: Org_Xrpl_Rpc_V1_XRPDropsAmount?
        if let current = self.amount {
          try decoder.handleConflictingOneOf()
          if case .xrpAmount(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.amount = .xrpAmount(v)}
      case 2:
        var v: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount?
        if let current = self.amount {
          try decoder.handleConflictingOneOf()
          if case .issuedCurrencyAmount(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.amount = .issuedCurrencyAmount(v)}
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    switch self.amount {
    case .xrpAmount(let v)?:
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    case .issuedCurrencyAmount(let v)?:
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_CurrencyAmount, rhs: Org_Xrpl_Rpc_V1_CurrencyAmount) -> Bool {
    if lhs.amount != rhs.amount {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Org_Xrpl_Rpc_V1_XRPDropsAmount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".XRPDropsAmount"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "drops"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt64Field(value: &self.drops)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.drops != 0 {
      try visitor.visitSingularUInt64Field(value: self.drops, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_XRPDropsAmount, rhs: Org_Xrpl_Rpc_V1_XRPDropsAmount) -> Bool {
    if lhs.drops != rhs.drops {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Org_Xrpl_Rpc_V1_IssuedCurrencyAmount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".IssuedCurrencyAmount"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "currency"),
    2: .same(proto: "value"),
    3: .same(proto: "issuer"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._currency)
      case 2: try decoder.decodeSingularStringField(value: &self.value)
      case 3: try decoder.decodeSingularMessageField(value: &self._issuer)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._currency {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.value.isEmpty {
      try visitor.visitSingularStringField(value: self.value, fieldNumber: 2)
    }
    if let v = self._issuer {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount, rhs: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount) -> Bool {
    if lhs._currency != rhs._currency {return false}
    if lhs.value != rhs.value {return false}
    if lhs._issuer != rhs._issuer {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Org_Xrpl_Rpc_V1_Currency: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Currency"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "code"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.name)
      case 2: try decoder.decodeSingularBytesField(value: &self.code)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    if !self.code.isEmpty {
      try visitor.visitSingularBytesField(value: self.code, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_Currency, rhs: Org_Xrpl_Rpc_V1_Currency) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs.code != rhs.code {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
