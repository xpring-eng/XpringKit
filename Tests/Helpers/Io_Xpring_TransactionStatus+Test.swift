import XpringKit

extension Io_Xpring_TransactionStatus {
  public static let testTransactionStatus = Io_Xpring_TransactionStatus.with {
    $0.validated = true
    $0.transactionStatusCode = .testTransactionStatusCodeSuccess
  }
}
