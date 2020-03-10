import XpringKit

/// A  fake XRPClient which returns the given iVars as results from XRPClientDecorator calls.
/// - Note: Since this class is passed by reference and the iVars are mutable, outputs of this class can be changed after it is injected.
public class FakeXRPClient {
  public let networkClient: LegacyNetworkClient = LegacyFakeNetworkClient.successfulFakeNetworkClient

  public var getBalanceValue: UInt64
  public var transactionStatusValue: TransactionStatus
  public var sendValue: TransactionHash
  public var latestValidatedLedgerValue: UInt32
  public var rawTransactionStatusValue: RawTransactionStatus
  public var transactionHistoryValue: [XRPTransaction]
  public var accountExistsValue: Bool

  public init(
    getBalanceValue: UInt64,
    transactionStatusValue: TransactionStatus,
    sendValue: TransactionHash,
    latestValidatedLedgerValue: UInt32,
    rawTransactionStatusValue: RawTransactionStatus,
    transactionHistoryValue: [XRPTransaction],
    accountExistsValue: Bool
  ) {
    self.getBalanceValue = getBalanceValue
    self.transactionStatusValue = transactionStatusValue
    self.sendValue = sendValue
    self.latestValidatedLedgerValue = latestValidatedLedgerValue
    self.rawTransactionStatusValue = rawTransactionStatusValue
    self.transactionHistoryValue = transactionHistoryValue
    self.accountExistsValue = accountExistsValue
  }
}

extension FakeXRPClient: XRPClientDecorator {
  public func getBalance(for address: Address) throws -> UInt64 {
    return getBalanceValue
  }

  public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return transactionStatusValue
  }

  public func send(_ amount: UInt64, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    return sendValue
  }

  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    return latestValidatedLedgerValue
  }

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    return rawTransactionStatusValue
  }

  public func getTransactionHistory(for address: Address) throws -> [XRPTransaction] {
    return transactionHistoryValue
  }

  public func accountExists(for address: Address) throws -> Bool {
    return accountExistsValue
  }
}
