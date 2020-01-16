import BigInt
import Foundation

/// A XpringClient which blocks on `send` calls until the transaction has reached a deterministic state.
public class LegacyReliableSubmissionXpringClient {
  private let decoratedClient: LegacyXpringClientDecorator

  public init(decoratedClient: LegacyXpringClientDecorator) {
    self.decoratedClient = decoratedClient
  }
}

extension LegacyReliableSubmissionXpringClient: LegacyXpringClientDecorator {
  public func getBalance(for address: Address) throws -> BigUInt {
    return try decoratedClient.getBalance(for: address)
  }

  public func getTx(for transactionHash: TransactionHash) throws -> Rpc_V1_GetTxResponse {
    return try decoratedClient.getTx(for: transactionHash)
  }

  public func getRawTx(for transactionHash: TransactionHash) throws -> Rpc_V1_GetTxResponse {
    return try decoratedClient.getRawTx(for: transactionHash)
  }

  public func submitTransaction(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Rpc_V1_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Rpc_V1_SubmitTransactionResponse {
    let ledgerCloseTime: TimeInterval = 4

    // Submit a transaction hash and wait for a ledger to close.
    let tx = try decoratedClient.submitTransaction(amount, to: destinationAddress, from: sourceWallet, invoiceID: invoiceID, memos: memos, flags: flags, sourceTag: sourceTag, accountTransactionID: accountTransactionID)
    Thread.sleep(forTimeInterval: ledgerCloseTime)

    // Get transaction status.
//    var tx = try getRawTx(for: tx)
    return tx
  }

    public func submitRawTransaction(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Rpc_V1_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Rpc_V1_SubmitTransactionResponse {
      return try decoratedClient.submitRawTransaction(amount, to: destinationAddress, from: sourceWallet, invoiceID: invoiceID, memos: memos, flags: flags, sourceTag: sourceTag, accountTransactionID: accountTransactionID)
    }
}
