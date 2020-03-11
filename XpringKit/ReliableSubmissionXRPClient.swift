import Foundation

/// A XRPClient which blocks on `send` calls until the transaction has reached a deterministic state.
public class ReliableSubmissionXRPClient {
  private let decoratedClient: XRPClientDecorator

  public init(decoratedClient: XRPClientDecorator) {
    self.decoratedClient = decoratedClient
  }
}

extension ReliableSubmissionXRPClient: XRPClientDecorator {
  public func getBalance(for address: Address) throws -> UInt64 {
    return try decoratedClient.getBalance(for: address)
  }

  public func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return try decoratedClient.paymentStatus(for: transactionHash)
  }

  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    return try decoratedClient.getLatestValidatedLedgerSequence()
  }

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    return try decoratedClient.getRawTransactionStatus(for: transactionHash)
  }

  public func send(_ amount: UInt64, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    let ledgerCloseTime: TimeInterval = 4

    // Submit a transaction hash and wait for a ledger to close.
    let transactionHash = try decoratedClient.send(amount, to: destinationAddress, from: sourceWallet)
    Thread.sleep(forTimeInterval: ledgerCloseTime)

    // Get transaction status.
    var transactionStatus = try getRawTransactionStatus(for: transactionHash)
    let lastLedgerSequence = transactionStatus.lastLedgerSequence
    if lastLedgerSequence == 0 {
      throw XRPLedgerError.unknown("The transaction did not have a lastLedgerSequence field so transaction status cannot be reliably determined.")
    }

    // Retrieve the latest ledger index.
    var latestLedgerSequence = try getLatestValidatedLedgerSequence()

    // Poll until the transaction is validated, or until the lastLedgerSequence has been passed.
    while latestLedgerSequence <= lastLedgerSequence && !transactionStatus.validated {
      Thread.sleep(forTimeInterval: ledgerCloseTime)

      latestLedgerSequence = try getLatestValidatedLedgerSequence()
      transactionStatus = try getRawTransactionStatus(for: transactionHash)
    }

    return transactionHash
  }

  public func accountExists(for address: Address) throws -> Bool {
    return try decoratedClient.accountExists(for: address)
  }

  public func getTransactionHistory(for address: Address) throws -> [Transaction] {
    return try decoratedClient.getTransactionHistory(for: address)
  }
}
