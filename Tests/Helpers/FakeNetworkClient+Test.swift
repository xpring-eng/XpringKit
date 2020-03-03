import XpringKit

extension FakeNetworkClient {
  /// A network client that always succeeds.
  static let successfulFakeNetworkClient = FakeNetworkClient(
    accountInfoResult: .success(.testGetAccountInfoResponse),
    feeResult: .success(.testGetFeeResponse),
    submitTransactionResult: .success(.testSubmitTransactionResponse),
    transactionStatusResult: .success(.testGetTransactionResponse)
  )
}
