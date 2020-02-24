import XpringKit

extension Io_Xpring_AccountInfo {
  static let testAccountInfo = Io_Xpring_AccountInfo.with {
    $0.balance = Io_Xpring_XRPAmount.with {
      $0.drops = String(UInt64.testBalance)
    }
    $0.sequence = .testSequence
  }
}
