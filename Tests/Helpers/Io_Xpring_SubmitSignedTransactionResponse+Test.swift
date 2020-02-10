import XpringKit

extension Io_Xpring_SubmitSignedTransactionResponse {
  static let testSubmitTransactionResponse = Io_Xpring_SubmitSignedTransactionResponse.with {
    $0.transactionBlob = .testTransactionBlobHex
  }
}
