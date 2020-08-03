import Foundation

/// A XRPClient which blocks on `send` calls until the transaction has reached a deterministic state.
public class ReliableSubmissionXRPClient {
  private let decoratedClient: XRPClientDecorator
  internal let network: XRPLNetwork

  internal init(decoratedClient: XRPClientDecorator, xrplNetwork: XRPLNetwork) {
    self.decoratedClient = decoratedClient
    self.network = xrplNetwork
  }
}

extension ReliableSubmissionXRPClient: XRPClientDecorator {
  public func getBalance(for address: Address) throws -> UInt64 {
    return try decoratedClient.getBalance(for: address)
  }

  public func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    return try decoratedClient.paymentStatus(for: transactionHash)
  }

  public func getLatestValidatedLedgerSequence(address: Address) throws -> UInt32 {
    return try decoratedClient.getLatestValidatedLedgerSequence(address: address)
  }

  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    return try decoratedClient.getRawTransactionStatus(for: transactionHash)
  }

  public func send(
    _ amount: UInt64,
    to destinationAddress: Address,
    from sourceWallet: Wallet
  ) throws -> TransactionHash {
    let transactionHash = try decoratedClient.send(amount, to: destinationAddress, from: sourceWallet)
    try self.awaitFinalTransactionResult(transactionHash: transactionHash, sourceWallet: sourceWallet)
    return transactionHash
  }

  public func accountExists(for address: Address) throws -> Bool {
    return try decoratedClient.accountExists(for: address)
  }

  public func paymentHistory(for address: Address) throws -> [XRPTransaction] {
    return try decoratedClient.paymentHistory(for: address)
  }

  public func getPayment(for transactionHash: String) throws -> XRPTransaction? {
    return try decoratedClient.getPayment(for: transactionHash)
  }

  public func enableDepositAuth(for wallet: Wallet) throws -> TransactionResult {
    let initialResult = try self.decoratedClient.enableDepositAuth(for: wallet)
    let transactionHash = initialResult.hash
    let finalStatus = try self.awaitFinalTransactionResult(transactionHash: transactionHash, sourceWallet: wallet)

    return TransactionResult(
      hash: initialResult.hash,
      status: try self.paymentStatus(for: transactionHash),
      validated: finalStatus.validated
    )
  }

  private func awaitFinalTransactionResult(
    transactionHash: String,
    sourceWallet: Wallet
  ) throws -> RawTransactionStatus {
    let ledgerCloseTime: TimeInterval = 4

    Thread.sleep(forTimeInterval: ledgerCloseTime)

    // Get transaction status.
    var transactionStatus = try getRawTransactionStatus(for: transactionHash)
    let lastLedgerSequence = transactionStatus.lastLedgerSequence
    if lastLedgerSequence == 0 {
      throw XRPLedgerError.unknown(
        "The transaction did not have a lastLedgerSequence field so transaction status cannot be reliably determined."
      )
    }

    // Decode the sending address to a classic address for use in determining the last ledger sequence.
    // An invariant of `getLatestValidatedLedgerSequence` is that the given input address (1) exists when the method
    // is called and (2) is in a classic address form.
    //
    // The sending address should always exist, except in the case where it is deleted. A deletion would supersede the
    // transaction in flight, either by:
    // 1) Consuming the nonce sequence number of the transaction, which would effectively cancel the transaction
    // 2) Occur after the transaction has settled which is an unlikely enough case that we ignore it.
    //
    // This logic is brittle and should be replaced when we have an RPC that can give us this data.
    guard let sourceAddressComponents = Utils.decode(xAddress: sourceWallet.address) else {
      throw XRPLedgerError.unknown(
        "The source wallet reported an address which could not be decoded to a classic address"
      )
    }
    let sourceClassicAddress = sourceAddressComponents.classicAddress

    // Retrieve the latest ledger index.
    var latestLedgerSequence = try getLatestValidatedLedgerSequence(address: sourceClassicAddress)

    // Poll until the transaction is validated, or until the lastLedgerSequence has been passed.
    while latestLedgerSequence <= lastLedgerSequence && !transactionStatus.validated {
      Thread.sleep(forTimeInterval: ledgerCloseTime)

      latestLedgerSequence = try getLatestValidatedLedgerSequence(address: sourceClassicAddress)
      transactionStatus = try getRawTransactionStatus(for: transactionHash)
    }

    return transactionStatus
  }
}
