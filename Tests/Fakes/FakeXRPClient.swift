import XpringKit

/// A  fake XRPClient which returns the given iVars as results from XRPClientDecorator calls.
/// - Note: Since this class is passed by reference and the instance variables are mutable, outputs of this class
///         can be changed after it is instantiated.
public class FakeXRPClient {
  public let networkClient = FakeNetworkClient.successfulFakeNetworkClient

  public var getBalanceValue: UInt64
  public var paymentStatusValue: TransactionStatus
  public var sendValue: TransactionHash
  public var latestValidatedLedgerValue: UInt32
  public var rawTransactionStatusValue: RawTransactionStatus
  public var paymentHistoryValue: [XRPTransaction]
  public var accountExistsValue: Bool

  public init(
    getBalanceValue: UInt64,
    paymentStatusValue: TransactionStatus,
    sendValue: TransactionHash,
    latestValidatedLedgerValue: UInt32,
    rawTransactionStatusValue: RawTransactionStatus,
    paymentHistoryValue: [XRPTransaction],
    accountExistsValue: Bool
  ) {
    self.getBalanceValue = getBalanceValue
    self.paymentStatusValue = paymentStatusValue
    self.sendValue = sendValue
    self.latestValidatedLedgerValue = latestValidatedLedgerValue
    self.rawTransactionStatusValue = rawTransactionStatusValue
    self.paymentHistoryValue = paymentHistoryValue
    self.accountExistsValue = accountExistsValue
  }
}

extension FakeXRPClient: XRPClientDecorator {
  public func getBalance(for address: Address) throws -> UInt64 {
    return getBalanceValue
  }

  public func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return paymentStatusValue
  }

  public func send(
    _ amount: UInt64,
    to destinationAddress: Address,
    from sourceWallet: Wallet
  ) throws -> TransactionHash {
    return sendValue
  }

  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    return latestValidatedLedgerValue
  }

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    return rawTransactionStatusValue
  }

  public func paymentHistory(for address: Address) throws -> [XRPTransaction] {
    return paymentHistoryValue
  }

  public func accountExists(for address: Address) throws -> Bool {
    return accountExistsValue
  }
}
