/// Flags used in AccountSet transactions.
///
/// These are only flags which are utilized in Xpring SDK.
/// For the complete list of AccountSet flags, see https://xrpl.org/accountset.html#accountset-flags
enum AccountSetFlag: UInt32 {
  case asfRequireDest = 1
  case asfRequireAuth = 2
  case asfDisallowXRP = 3
  case asfDisableMaster = 4
  case asfAccountTxnId = 5
  case asfNoFreeze = 6
  case asfGlobalFreeze = 7
  case asfDefaultRipple = 8
  case asfDepositAuth = 9
}
