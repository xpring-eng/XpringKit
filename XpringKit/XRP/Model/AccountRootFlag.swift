/// There are several options which can be either enabled or disabled for an XRPL account using AccountSet transactions.
/// These options are indicated in a bitmap of AccountRoot flags.  The bit values for the flags in the ledger are
/// different from the values used to enable or disable those flags in a transaction.
/// Ledger flags have names that begin with lsf.
///
/// These are only flags which are utilized in Xpring SDK.
/// For the complete list of AccountRoot flags, see https://xrpl.org/accountroot.html#accountroot-flags
public struct AccountRootFlag: OptionSet {
  public let rawValue: UInt32

  /// Flag values.
  public static let lsfDepositAuth = AccountRootFlag(rawValue: 1 << 24) // 16777216

  /// Initialize a new AccountRootFlag
  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
  
  public func check(flag: AccountRootFlag, flags: UInt32) -> Bool {
    return (flag.rawValue & flags) == flag.rawValue;
  }
}
