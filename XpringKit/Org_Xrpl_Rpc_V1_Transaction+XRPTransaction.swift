import Foundation

internal extension XRPTransaction {
  private static let javaScriptUtils = JavaScriptUtils()

  init?(getTransactionResponse: Org_Xrpl_Rpc_V1_GetTransactionResponse) {

    let transaction: Org_Xrpl_Rpc_V1_Transaction = getTransactionResponse.transaction

    self.hash = XRPTransaction.javaScriptUtils.toHex(bytes: getTransactionResponse.hash)
    self.account = transaction.account.value.address
    self.fee = transaction.fee.drops
    self.sequence = transaction.sequence.value
    self.signingPublicKey = transaction.signingPublicKey.value
    self.transactionSignature = transaction.transactionSignature.value

    self.accountTransactionID = transaction.hasAccountTransactionID ? transaction.accountTransactionID.value : nil
    self.flags = transaction.hasFlags ? RippledFlags(rawValue: transaction.flags.value) : nil
    self.lastLedgerSequence = transaction.hasLastLedgerSequence ? transaction.lastLedgerSequence.value : nil
    self.memos = !transaction.memos.isEmpty ? transaction.memos.map { memo in XRPMemo(memo: memo) } : nil
    self.signers = !transaction.signers.isEmpty ? transaction.signers.map { signer in XRPSigner(signer: signer) } : nil
    self.sourceTag = transaction.hasSourceTag ? transaction.sourceTag.value : nil

    switch transaction.transactionData {
    case .payment(let payment):
      guard let paymentFields = XRPPayment(payment: payment) else {
        return nil
      }
      self.paymentFields = paymentFields
      self.type = .payment
    default:
      // Unsupported transaction type.
      return nil
    }

    // Transactions report their timestamps since the Ripple Epoch, which is 946,684,800 seconds
    // after the unix epoch. Convert transaction's timestamp to a unix timestamp.
    // - SeeAlso: https://xrpl.org/basic-data-types.html#specifying-time
    if getTransactionResponse.hasDate {
      let rippleTransactionDate = UInt64(getTransactionResponse.date.value)
      self.timestamp = rippleTransactionDate + 946_684_800
    } else {
      self.timestamp = nil
    }

    if getTransactionResponse.meta.hasDeliveredAmount && getTransactionResponse.meta.deliveredAmount.hasValue {
      let amountCase = getTransactionResponse.meta.deliveredAmount.value.amount
      switch amountCase {
      case .xrpAmount:
        self.deliveredAmount = String(getTransactionResponse.meta.deliveredAmount.value.xrpAmount.drops)
      case .issuedCurrencyAmount:
        self.deliveredAmount = getTransactionResponse.meta.deliveredAmount.value.issuedCurrencyAmount.value
      case .none:
        self.deliveredAmount = nil
      }
    } else {
      self.deliveredAmount = nil
    }
  }
}
