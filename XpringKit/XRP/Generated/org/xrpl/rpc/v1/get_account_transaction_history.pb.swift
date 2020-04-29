// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: org/xrpl/rpc/v1/get_account_transaction_history.proto
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

/// Next field: 8
public struct Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var account: Org_Xrpl_Rpc_V1_AccountAddress {
    get {return _storage._account ?? Org_Xrpl_Rpc_V1_AccountAddress()}
    set {_uniqueStorage()._account = newValue}
  }
  /// Returns true if `account` has been explicitly set.
  public var hasAccount: Bool {return _storage._account != nil}
  /// Clears the value of `account`. Subsequent reads from it will return its default value.
  public mutating func clearAccount() {_uniqueStorage()._account = nil}

  /// What ledger to include results from. Specifying a not yet validated
  /// ledger results in an error. Not specifying a ledger uses the entire
  /// range of validated ledgers available to the server.
  public var ledger: OneOf_Ledger? {
    get {return _storage._ledger}
    set {_uniqueStorage()._ledger = newValue}
  }

  public var ledgerSpecifier: Org_Xrpl_Rpc_V1_LedgerSpecifier {
    get {
      if case .ledgerSpecifier(let v)? = _storage._ledger {return v}
      return Org_Xrpl_Rpc_V1_LedgerSpecifier()
    }
    set {_uniqueStorage()._ledger = .ledgerSpecifier(newValue)}
  }

  public var ledgerRange: Org_Xrpl_Rpc_V1_LedgerRange {
    get {
      if case .ledgerRange(let v)? = _storage._ledger {return v}
      return Org_Xrpl_Rpc_V1_LedgerRange()
    }
    set {_uniqueStorage()._ledger = .ledgerRange(newValue)}
  }

  /// Return results as binary blobs. Defaults to false.
  public var binary: Bool {
    get {return _storage._binary}
    set {_uniqueStorage()._binary = newValue}
  }

  /// If set to true, returns values indexed by older ledger first.
  /// Default to false.
  public var forward: Bool {
    get {return _storage._forward}
    set {_uniqueStorage()._forward = newValue}
  }

  /// Limit the number of results. Server may choose a lower limit.
  /// If this value is 0, the limit is ignored and the number of results
  /// returned is determined by the server
  public var limit: UInt32 {
    get {return _storage._limit}
    set {_uniqueStorage()._limit = newValue}
  }

  /// Marker to resume where previous request left off
  /// Used for pagination
  public var marker: Org_Xrpl_Rpc_V1_Marker {
    get {return _storage._marker ?? Org_Xrpl_Rpc_V1_Marker()}
    set {_uniqueStorage()._marker = newValue}
  }
  /// Returns true if `marker` has been explicitly set.
  public var hasMarker: Bool {return _storage._marker != nil}
  /// Clears the value of `marker`. Subsequent reads from it will return its default value.
  public mutating func clearMarker() {_uniqueStorage()._marker = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// What ledger to include results from. Specifying a not yet validated
  /// ledger results in an error. Not specifying a ledger uses the entire
  /// range of validated ledgers available to the server.
  public enum OneOf_Ledger: Equatable {
    case ledgerSpecifier(Org_Xrpl_Rpc_V1_LedgerSpecifier)
    case ledgerRange(Org_Xrpl_Rpc_V1_LedgerRange)

  #if !swift(>=4.1)
    public static func ==(lhs: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest.OneOf_Ledger, rhs: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest.OneOf_Ledger) -> Bool {
      switch (lhs, rhs) {
      case (.ledgerSpecifier(let l), .ledgerSpecifier(let r)): return l == r
      case (.ledgerRange(let l), .ledgerRange(let r)): return l == r
      default: return false
      }
    }
  #endif
  }

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

/// Next field: 8
public struct Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var account: Org_Xrpl_Rpc_V1_AccountAddress {
    get {return _storage._account ?? Org_Xrpl_Rpc_V1_AccountAddress()}
    set {_uniqueStorage()._account = newValue}
  }
  /// Returns true if `account` has been explicitly set.
  public var hasAccount: Bool {return _storage._account != nil}
  /// Clears the value of `account`. Subsequent reads from it will return its default value.
  public mutating func clearAccount() {_uniqueStorage()._account = nil}

  public var ledgerIndexMin: UInt32 {
    get {return _storage._ledgerIndexMin}
    set {_uniqueStorage()._ledgerIndexMin = newValue}
  }

  public var ledgerIndexMax: UInt32 {
    get {return _storage._ledgerIndexMax}
    set {_uniqueStorage()._ledgerIndexMax = newValue}
  }

  public var limit: UInt32 {
    get {return _storage._limit}
    set {_uniqueStorage()._limit = newValue}
  }

  public var marker: Org_Xrpl_Rpc_V1_Marker {
    get {return _storage._marker ?? Org_Xrpl_Rpc_V1_Marker()}
    set {_uniqueStorage()._marker = newValue}
  }
  /// Returns true if `marker` has been explicitly set.
  public var hasMarker: Bool {return _storage._marker != nil}
  /// Clears the value of `marker`. Subsequent reads from it will return its default value.
  public mutating func clearMarker() {_uniqueStorage()._marker = nil}

  public var transactions: [Org_Xrpl_Rpc_V1_GetTransactionResponse] {
    get {return _storage._transactions}
    set {_uniqueStorage()._transactions = newValue}
  }

  public var validated: Bool {
    get {return _storage._validated}
    set {_uniqueStorage()._validated = newValue}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

/// Next field: 3
public struct Org_Xrpl_Rpc_V1_Marker {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var ledgerIndex: UInt32 = 0

  public var accountSequence: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "org.xrpl.rpc.v1"

extension Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".GetAccountTransactionHistoryRequest"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "account"),
    2: .standard(proto: "ledger_specifier"),
    3: .standard(proto: "ledger_range"),
    4: .same(proto: "binary"),
    5: .same(proto: "forward"),
    6: .same(proto: "limit"),
    7: .same(proto: "marker"),
  ]

  fileprivate class _StorageClass {
    var _account: Org_Xrpl_Rpc_V1_AccountAddress? = nil
    var _ledger: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest.OneOf_Ledger?
    var _binary: Bool = false
    var _forward: Bool = false
    var _limit: UInt32 = 0
    var _marker: Org_Xrpl_Rpc_V1_Marker? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _account = source._account
      _ledger = source._ledger
      _binary = source._binary
      _forward = source._forward
      _limit = source._limit
      _marker = source._marker
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
        case 1: try decoder.decodeSingularMessageField(value: &_storage._account)
        case 2:
          var v: Org_Xrpl_Rpc_V1_LedgerSpecifier?
          if let current = _storage._ledger {
            try decoder.handleConflictingOneOf()
            if case .ledgerSpecifier(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._ledger = .ledgerSpecifier(v)}
        case 3:
          var v: Org_Xrpl_Rpc_V1_LedgerRange?
          if let current = _storage._ledger {
            try decoder.handleConflictingOneOf()
            if case .ledgerRange(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._ledger = .ledgerRange(v)}
        case 4: try decoder.decodeSingularBoolField(value: &_storage._binary)
        case 5: try decoder.decodeSingularBoolField(value: &_storage._forward)
        case 6: try decoder.decodeSingularUInt32Field(value: &_storage._limit)
        case 7: try decoder.decodeSingularMessageField(value: &_storage._marker)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._account {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      switch _storage._ledger {
      case .ledgerSpecifier(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      case .ledgerRange(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      case nil: break
      }
      if _storage._binary != false {
        try visitor.visitSingularBoolField(value: _storage._binary, fieldNumber: 4)
      }
      if _storage._forward != false {
        try visitor.visitSingularBoolField(value: _storage._forward, fieldNumber: 5)
      }
      if _storage._limit != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._limit, fieldNumber: 6)
      }
      if let v = _storage._marker {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest, rhs: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._account != rhs_storage._account {return false}
        if _storage._ledger != rhs_storage._ledger {return false}
        if _storage._binary != rhs_storage._binary {return false}
        if _storage._forward != rhs_storage._forward {return false}
        if _storage._limit != rhs_storage._limit {return false}
        if _storage._marker != rhs_storage._marker {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".GetAccountTransactionHistoryResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "account"),
    2: .standard(proto: "ledger_index_min"),
    3: .standard(proto: "ledger_index_max"),
    4: .same(proto: "limit"),
    5: .same(proto: "marker"),
    6: .same(proto: "transactions"),
    7: .same(proto: "validated"),
  ]

  fileprivate class _StorageClass {
    var _account: Org_Xrpl_Rpc_V1_AccountAddress? = nil
    var _ledgerIndexMin: UInt32 = 0
    var _ledgerIndexMax: UInt32 = 0
    var _limit: UInt32 = 0
    var _marker: Org_Xrpl_Rpc_V1_Marker? = nil
    var _transactions: [Org_Xrpl_Rpc_V1_GetTransactionResponse] = []
    var _validated: Bool = false

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _account = source._account
      _ledgerIndexMin = source._ledgerIndexMin
      _ledgerIndexMax = source._ledgerIndexMax
      _limit = source._limit
      _marker = source._marker
      _transactions = source._transactions
      _validated = source._validated
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
        case 1: try decoder.decodeSingularMessageField(value: &_storage._account)
        case 2: try decoder.decodeSingularUInt32Field(value: &_storage._ledgerIndexMin)
        case 3: try decoder.decodeSingularUInt32Field(value: &_storage._ledgerIndexMax)
        case 4: try decoder.decodeSingularUInt32Field(value: &_storage._limit)
        case 5: try decoder.decodeSingularMessageField(value: &_storage._marker)
        case 6: try decoder.decodeRepeatedMessageField(value: &_storage._transactions)
        case 7: try decoder.decodeSingularBoolField(value: &_storage._validated)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._account {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      if _storage._ledgerIndexMin != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._ledgerIndexMin, fieldNumber: 2)
      }
      if _storage._ledgerIndexMax != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._ledgerIndexMax, fieldNumber: 3)
      }
      if _storage._limit != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._limit, fieldNumber: 4)
      }
      if let v = _storage._marker {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      }
      if !_storage._transactions.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._transactions, fieldNumber: 6)
      }
      if _storage._validated != false {
        try visitor.visitSingularBoolField(value: _storage._validated, fieldNumber: 7)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse, rhs: Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryResponse) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._account != rhs_storage._account {return false}
        if _storage._ledgerIndexMin != rhs_storage._ledgerIndexMin {return false}
        if _storage._ledgerIndexMax != rhs_storage._ledgerIndexMax {return false}
        if _storage._limit != rhs_storage._limit {return false}
        if _storage._marker != rhs_storage._marker {return false}
        if _storage._transactions != rhs_storage._transactions {return false}
        if _storage._validated != rhs_storage._validated {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Org_Xrpl_Rpc_V1_Marker: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Marker"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "ledger_index"),
    2: .standard(proto: "account_sequence"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt32Field(value: &self.ledgerIndex)
      case 2: try decoder.decodeSingularUInt32Field(value: &self.accountSequence)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.ledgerIndex != 0 {
      try visitor.visitSingularUInt32Field(value: self.ledgerIndex, fieldNumber: 1)
    }
    if self.accountSequence != 0 {
      try visitor.visitSingularUInt32Field(value: self.accountSequence, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Org_Xrpl_Rpc_V1_Marker, rhs: Org_Xrpl_Rpc_V1_Marker) -> Bool {
    if lhs.ledgerIndex != rhs.ledgerIndex {return false}
    if lhs.accountSequence != rhs.accountSequence {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
