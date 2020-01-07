// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: fiat_amount.proto
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

/// A representation of an amount of currency in fiat.
/// Next field: 4
public struct Io_Xpring_FiatAmount {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The currency used to value the amount.
  public var currency: Io_Xpring_Currency {
    get {return _storage._currency ?? Io_Xpring_Currency()}
    set {_uniqueStorage()._currency = newValue}
  }
  /// Returns true if `currency` has been explicitly set.
  public var hasCurrency: Bool {return _storage._currency != nil}
  /// Clears the value of `currency`. Subsequent reads from it will return its default value.
  public mutating func clearCurrency() {_uniqueStorage()._currency = nil}

  /// The value of the amount.
  public var value: String {
    get {return _storage._value}
    set {_uniqueStorage()._value = newValue}
  }

  /// Unique account address of the entity issuing the currency.
  public var issuer: String {
    get {return _storage._issuer}
    set {_uniqueStorage()._issuer = newValue}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "io.xpring"

extension Io_Xpring_FiatAmount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FiatAmount"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "currency"),
    2: .same(proto: "value"),
    3: .same(proto: "issuer"),
  ]

  fileprivate class _StorageClass {
    var _currency: Io_Xpring_Currency? = nil
    var _value: String = String()
    var _issuer: String = String()

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _currency = source._currency
      _value = source._value
      _issuer = source._issuer
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularMessageField(value: &_storage._currency)
        case 2: try decoder.decodeSingularStringField(value: &_storage._value)
        case 3: try decoder.decodeSingularStringField(value: &_storage._issuer)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._currency {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      if !_storage._value.isEmpty {
        try visitor.visitSingularStringField(value: _storage._value, fieldNumber: 2)
      }
      if !_storage._issuer.isEmpty {
        try visitor.visitSingularStringField(value: _storage._issuer, fieldNumber: 3)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Io_Xpring_FiatAmount, rhs: Io_Xpring_FiatAmount) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._currency != rhs_storage._currency {return false}
        if _storage._value != rhs_storage._value {return false}
        if _storage._issuer != rhs_storage._issuer {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
