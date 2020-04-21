import Foundation

/// Conforms to XRPTransaction struct while providing an initializer that can construct an XRPTransaction
/// from an Org_Xrpl_Rpc_V1_Transaction
internal extension XRPTransaction {

  /// Constructs an XRPTransaction from an Org_Xrpl_Rpc_V1_Transaction
  /// - SeeAlso: [Transaction Protocol Buffer]
  /// (https://github.com/ripple/rippled/blob/develop/src/ripple/proto/org/xrpl/rpc/v1/transaction.proto#L13)
  ///
  /// - Parameters:
  ///     - transaction: an Org_Xrpl_Rpc_V1_Transaction (protobuf object) whose field values will be used to
  ///                 construct an XRPTransaction
  /// - Returns: an XRPTransaction with its fields set via the analogous protobuf fields.
  init?(transaction: Org_Xrpl_Rpc_V1_Transaction) {
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
  }
}
