import XpringKit

extension Io_Xpring_Fee {
  static let testFee = Io_Xpring_Fee.with {
    $0.amount = Io_Xpring_XRPAmount.with {
      $0.drops = .testFeeDrops
    }
  }
}
