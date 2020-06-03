import SwiftGRPC
@testable import XpringKit

/// A  fake XRPClient which returns the given iVars as results from XRPClientDecorator calls.
///
/// - Note: Since this class is passed by reference and the instance variables are mutable, outputs of this class
///         can be changed after it is instantiated.
public class FakeXRPClient: XRPClientProtocol {
  public let network: XRPLNetwork
  public let xrplNetwork: XRPLNetwork

  public let networkClient = FakeNetworkClient.successfulFakeNetworkClient

  public var getBalanceValue: Result<UInt64, XRPLedgerError>
  public var paymentStatusValue: Result<TransactionStatus, XRPLedgerError>
  public var sendValue: Result<TransactionHash, XRPLedgerError>
  public var latestValidatedLedgerValue: Result<UInt32, XRPLedgerError>
  public var rawTransactionStatusValue: Result<RawTransactionStatus, XRPLedgerError>
  public var paymentHistoryValue: Result<[XRPTransaction], XRPLedgerError>
  public var accountExistsValue: Result<Bool, XRPLedgerError>
  public var getPaymentValue: Result<XRPTransaction?, RPCError>

  public init(
    network: XRPLNetwork = .test,
    xrplNetwork: XRPLNetwork = .test,
    getBalanceValue: Result<UInt64, XRPLedgerError>,
    paymentStatusValue: Result<TransactionStatus, XRPLedgerError>,
    sendValue: Result<TransactionHash, XRPLedgerError>,
    latestValidatedLedgerValue: Result<UInt32, XRPLedgerError>,
    rawTransactionStatusValue: Result<RawTransactionStatus, XRPLedgerError>,
    paymentHistoryValue: Result<[XRPTransaction], XRPLedgerError>,
    accountExistsValue: Result<Bool, XRPLedgerError>,
    getPaymentValue: Result<XRPTransaction?, RPCError>
  ) {
    self.network = xrplNetwork
    self.xrplNetwork = xrplNetwork
    self.getBalanceValue = getBalanceValue
    self.paymentStatusValue = paymentStatusValue
    self.sendValue = sendValue
    self.latestValidatedLedgerValue = latestValidatedLedgerValue
    self.rawTransactionStatusValue = rawTransactionStatusValue
    self.paymentHistoryValue = paymentHistoryValue
    self.accountExistsValue = accountExistsValue
    self.getPaymentValue = getPaymentValue
  }
}

extension FakeXRPClient: XRPClientDecorator {
  public func getBalance(for address: Address) throws -> UInt64 {
    return try returnOrThrow(result: getBalanceValue)
  }

  public func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return try returnOrThrow(result: paymentStatusValue)
  }

  public func send(
    _ amount: UInt64,
    to destinationAddress: Address,
    from sourceWallet: Wallet
  ) throws -> TransactionHash {
    return try returnOrThrow(result: sendValue)
  }

  public func getLatestValidatedLedgerSequence(address: Address) throws -> UInt32 {
    return try returnOrThrow(result: latestValidatedLedgerValue)
  }

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    return try returnOrThrow(result: rawTransactionStatusValue)
  }

  public func paymentHistory(for address: Address) throws -> [XRPTransaction] {
    return try returnOrThrow(result: paymentHistoryValue)
  }

  public func accountExists(for address: Address) throws -> Bool {
    return try returnOrThrow(result: accountExistsValue)
  }

  public func getPayment(for transactionHash: TransactionHash) throws -> XRPTransaction? {
    switch getPaymentValue {
    case .success(let value):
      return value
    case .failure(let error):
      throw error
    }
  }

  /// Given a result monad, return the value if the state is success, otherwise throw the error.
  private func returnOrThrow<T>(result: Result<T, XRPLedgerError>) throws -> T {
    switch result {
    case .success(let value):
      return value
    case .failure(let error):
      throw error
    }
  }
}
