import XpringKit

/// A  fake XpringClient which returns the given iVars as results from XpringClientDecorator calls.
/// - Note: Since this class is passed by reference and the iVars are mutable, outputs of this class can be changed after it is injected.
public class FakeXpringClient {
  public let networkClient: LegacyNetworkClient = LegacyFakeNetworkClient.successfulFakeNetworkClient

  public var getBalanceValue: UInt64
  public var transactionStatusValue: TransactionStatus
  public var sendValue: TransactionHash
  public var latestValidatedLedgerValue: UInt32
  public var rawTransactionStatusValue: Io_Xpring_TransactionStatus

  public init(
    getBalanceValue: UInt64,
    transactionStatusValue: TransactionStatus,
    sendValue: TransactionHash,
    latestValidatedLedgerValue: UInt32,
    rawTransactionStatusValue: Io_Xpring_TransactionStatus
  ) {
    self.getBalanceValue = getBalanceValue
    self.transactionStatusValue = transactionStatusValue
    self.sendValue = sendValue
    self.latestValidatedLedgerValue = latestValidatedLedgerValue
    self.rawTransactionStatusValue = rawTransactionStatusValue
  }
}

extension FakeXpringClient: XpringClientDecorator {
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

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionStatus {
    return rawTransactionStatusValue
  }
}
