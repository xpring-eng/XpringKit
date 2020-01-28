import BigInt
import XpringKit

/// A  fake XpringClient which returns the given iVars as results from XpringClientDecorator calls.
/// - Note: Since this class is passed by reference and the iVars are mutable, outputs of this class can be changed after it is injected.
public class FakeXpringClient {
  public let networkClient: LegacyNetworkClient = LegacyFakeNetworkClient.successfulFakeNetworkClient

  public var getBalanceValue: BigUInt
  public var transactionStatusValue: TransactionStatus
  public var sendValue: TransactionHash
  public var latestValidatedLedgerValue: UInt32
  public var rawTransactionStatusValue: RawTransactionStatus

  public init(
    getBalanceValue: BigUInt,
    transactionStatusValue: TransactionStatus,
    sendValue: TransactionHash,
    latestValidatedLedgerValue: UInt32,
    rawTransactionStatusValue: RawTransactionStatus
  ) {
    self.getBalanceValue = getBalanceValue
    self.transactionStatusValue = transactionStatusValue
    self.sendValue = sendValue
    self.latestValidatedLedgerValue = latestValidatedLedgerValue
    self.rawTransactionStatusValue = rawTransactionStatusValue
  }
}

extension FakeXpringClient: XpringClientDecorator {
  public func getBalance(for address: Address) throws -> BigUInt {
    return getBalanceValue
  }

  public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return transactionStatusValue
  }

  public func send(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    return sendValue
  }

  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    return latestValidatedLedgerValue
  }

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    return rawTransactionStatusValue
  }
}
