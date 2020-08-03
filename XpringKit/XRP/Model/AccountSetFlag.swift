/// Flags used in AccountSet transactions.
///
/// These are only flags which are utilized in Xpring SDK.
/// For the complete list of AccountSet flags, see https://xrpl.org/accountset.html#accountset-flags
enum AccountSetFlag: UInt32 {
  case ASF_REQUIRE_DEST = 1
  case ASF_REQUIRE_AUTH = 2
  case ASF_DISALLOW_XRP = 3
  case ASF_DISABLE_MASTER = 4
  case ASF_ACCOUNT_TXN_ID = 5
  case ASF_NO_FREEZE = 6
  case ASF_GLOBAL_FREEZE = 7
  case ASF_DEFAULT_RIPPLE = 8
  case ASF_DEPOSIT_AUTH = 9
}
