import XpringKit

extension Io_Xpring_LedgerSequence {
  static let testLedgerSequence = Io_Xpring_LedgerSequence.with {
    $0.index = 12
  }
}
