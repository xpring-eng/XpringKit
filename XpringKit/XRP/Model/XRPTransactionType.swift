/// Types of transactions on the XRP Ledger.
///
/// This is a partial list. Please file an issue if you have a use case that requires additional types.
///
/// - SeeAlso: https://xrpl.org/transaction-formats.html
public enum XRPTransactionType {
  case accountSet
  case accountDelete
  case checkCancel
  case checkCash
  case checkCreate
  case depositPreauth
  case escrowCancel
  case escrowCreate
  case offerCancel
  case offerCreate
  case payment
  case paymentChannelClaim
}
