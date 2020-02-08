extension LegacyFakeNetworkClient {
  /// A network client that always succeeds.
  static let successfulFakeNetworkClient = LegacyFakeNetworkClient(
    accountInfoResult: .success(.testAccountInfo),
    feeResult: .success(.testFee),
    submitSignedTransactionResult: .success(.testSubmitTransactionResponse),
    latestValidatedLedgerSequenceResult: .success(.testLedgerSequence),
    transactionStatusResult: .success(.testTransactionStatus)
  )
}
