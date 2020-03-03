import BigInt
import Foundation

// TODO(keefertaylor): rebase file to be in XRP
// TODO(keefertaylor): Consider if we should encode addresses as X-Address.

/// Types of transactions on the XRP Ledger.
public enum XRPTransactionType {
  case payment
  case accountSet
  case accountDelete
  case checkCancel
  case checkCash
  case checkCreate
  case depositPreauth
  case escrowCancel
  case escrowCreate
  case escrowFinish
  case offerCancel
  case offerCreate
  case paymentChannelClaim
  case paymentChannelCreate
  case paymentChannelFund
  case setRegularKey
  case signerListSet
  case trustSet
}

/// A transaction on the XRP Ledger.
///
/// - SeeAlso: https://xrpl.org/transaction-formats.html
// TODO: X-Address
public struct XRPTransaction: Equatable {
  /// Common fields
  public let account: Address
  public let accountTransactionID: Data?
  public let feeDrops: UInt64
  public let flags: RippledFlags?
  public let lastLedgerSequence: UInt32?
  public let memos: [XRPMemo]?
  public let sequence: UInt32
  public let signers: [XRPSigner]?
  public let signingPublicKey: Data
  public let sourceTag: UInt32?
  public let transactionSignature: Data
  public let type: XRPTransactionType

  /// Transaction specific fields, only one of the following will be set.
  public let accountSetFields: XRPAccountSet?
  public let accountDeleteFields: XRPAccountDelete?
  public let checkCancelFields: XRPCheckCancel?
  public let checkCashFields: XRPCheckCash?
  public let checkCreateFields: XRPCheckCreate?
  public let depositPreauthFields: XRPDepositPreauth?
  public let escrowCancelFields: XRPEscrowCancel?
  public let escrowCreateFields: XRPEscrowCreate?
  public let escrowFinishFields: XRPEscrowFinish?
  public let offerCancelFields: XRPOfferCancel?
  public let offerCreateFields: XRPOfferCreate?
  public let paymentFields: XRPPayment?
  public let paymentChannelClaimFields: XRPPaymentChannelClaim?
  public let paymentChannelCreateFields: XRPPaymentChannelCreate?
  public let paymentChannelFundFields: XRPPaymentChannelFund?
  public let setRegularKeyFields: XRPSetRegularKey?
  public let signerListSetFields: XRPSignerListSet?
  public let trustSetFields: XRPTrustSet?
}

internal extension XRPTransaction {
  init?(transaction: Org_Xrpl_Rpc_V1_Transaction) {
    self.account = transaction.account.value.address
    self.feeDrops = transaction.fee.drops
    self.sequence = transaction.sequence.value
    self.signingPublicKey = transaction.signingPublicKey.value
    self.transactionSignature = transaction.transactionSignature.value

    self.accountTransactionID = transaction.hasAccountTransactionID ? transaction.accountTransactionID.value : nil
    self.flags = transaction.hasFee ? RippledFlags(rawValue: transaction.flags.value) : nil
    self.lastLedgerSequence = transaction.hasLastLedgerSequence ? transaction.lastLedgerSequence.value : nil
    self.memos = transaction.memos.count > 0 ? transaction.memos.map { memo in XRPMemo(memo: memo) } : nil
    self.signers = transaction.signers.count > 0 ? transaction.signers.map { signer in XRPSigner(signer: signer) } : nil
    self.sourceTag = transaction.hasSourceTag ? transaction.sourceTag.value : nil

    // TODO(keefertaylor): Some of these types are nullable. Check that they come back correctly via guards.
    switch transaction.transactionData {
    case .accountDelete(let accountDelete):
      self.type = .accountDelete
      self.accountDeleteFields = XRPAccountDelete(accountDelete: accountDelete)

      self.accountSetFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .accountSet(let accountSet):
      self.type = .accountSet
      self.accountSetFields = XRPAccountSet(accountSet: accountSet)

      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .checkCash(let checkCash):
      self.type = .checkCash
      self.checkCashFields = XRPCheckCash(checkCash: checkCash)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .checkCancel(let checkCancel):
      self.type = .checkCancel
      self.checkCancelFields = XRPCheckCancel(checkCancel: checkCancel)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .checkCreate(let checkCreate):
      self.type = .checkCreate
      self.checkCreateFields = XRPCheckCreate(checkCreate: checkCreate)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .depositPreauth(let depositPreauth):
      self.type = .depositPreauth
      self.depositPreauthFields = XRPDepositPreauth(depositPreauth: depositPreauth)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .escrowCancel(let escrowCancel):
      self.type = .escrowCancel
      self.escrowCancelFields = XRPEscrowCancel(escrowCancel: escrowCancel)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .escrowCreate(let escrowCreate):
      self.type = .escrowCreate
      self.escrowCreateFields = XRPEscrowCreate(escrowCreate: escrowCreate)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .escrowFinish(let escrowFinish):
      self.type = .escrowFinish
      self.escrowFinishFields = XRPEscrowFinish(escrowFinish: escrowFinish)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .offerCancel(let offerCancel):
      self.type = .offerCancel
      self.offerCancelFields = XRPOfferCancel(offerCancel: offerCancel)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .offerCreate(let offerCreate):
      self.type = .offerCreate
      self.offerCreateFields = XRPOfferCreate(offerCreate: offerCreate)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .payment(let payment):
      self.type = .payment
      self.paymentFields = XRPPayment(payment: payment)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .paymentChannelCreate(let paymentChannelCreate):
      self.type = .paymentChannelCreate
      self.paymentChannelCreateFields = XRPPaymentChannelCreate(paymentChannelCreate: paymentChannelCreate)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .paymentChannelClaim(let paymentChannelClaim):
      self.type = .paymentChannelClaim
      self.paymentChannelClaimFields = XRPPaymentChannelClaim(paymentChannelClaim: paymentChannelClaim)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .paymentChannelFund(let paymentChannelFund):
      self.type = .paymentChannelFund
      self.paymentChannelFundFields = XRPPaymentChannelFund(paymentChannelFund: paymentChannelFund)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .setRegularKey(let setRegularKey):
      self.type = .setRegularKey
      self.setRegularKeyFields = XRPSetRegularKey(setRegularKey: setRegularKey)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.signerListSetFields = nil
      self.trustSetFields = nil
    case .signerListSet(let signerListSet):
      self.type = .signerListSet
      self.signerListSetFields = XRPSignerListSet(signerListSet: signerListSet)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.trustSetFields = nil
    case .trustSet(let trustSet):
      self.type = .trustSet
      self.trustSetFields = XRPTrustSet(trustSet: trustSet)

      self.accountSetFields = nil
      self.accountDeleteFields = nil
      self.checkCancelFields = nil
      self.checkCashFields = nil
      self.checkCreateFields = nil
      self.depositPreauthFields = nil
      self.escrowCancelFields = nil
      self.escrowCreateFields = nil
      self.escrowFinishFields = nil
      self.offerCancelFields = nil
      self.offerCreateFields = nil
      self.paymentFields = nil
      self.paymentChannelClaimFields = nil
      self.paymentChannelCreateFields = nil
      self.paymentChannelFundFields = nil
      self.setRegularKeyFields = nil
      self.signerListSetFields = nil
    case .none:
      return nil
    }
  }
}

public struct XRPMemo: Equatable {
  public let data: Data?
  public let format: Data?
  public let type: Data?
}

internal extension XRPMemo {
  init(memo: Org_Xrpl_Rpc_V1_Memo) {
    self.data = memo.hasMemoData ? memo.memoData.value : nil
    self.format = memo.hasMemoFormat ? memo.memoFormat.value : nil
    self.type = memo.hasMemoType ? memo.memoType.value : nil
  }
}

public struct XRPSigner: Equatable {
  public let account: Address
  public let signingPublicKey: Data
  public let transactionSignature: Data
}

internal extension XRPSigner {
  init(signer: Org_Xrpl_Rpc_V1_Signer) {
    self.account = signer.account.value.address
    self.signingPublicKey = signer.signingPublicKey.value
    self.transactionSignature = signer.transactionSignature.value
  }
}

public struct XRPAccountSet: Equatable {
  public let clearFlag: UInt32?
  public let domain: String?
  public let emailHash: Data?
  public let messageKey: Data?
  public let setFlag: UInt32?
  public let transferRate: UInt32?
  public let tickSize: UInt8?
}

internal extension XRPAccountSet {
  init(accountSet: Org_Xrpl_Rpc_V1_AccountSet) {
    self.clearFlag = accountSet.hasClearFlag_p ? accountSet.clearFlag_p.value : nil
    self.domain = accountSet.hasDomain ? accountSet.domain.value : nil
    self.emailHash = accountSet.hasEmailHash ? accountSet.emailHash.value : nil
    self.messageKey = accountSet.hasMessageKey ? accountSet.messageKey.value : nil
    self.setFlag = accountSet.hasSetFlag ? accountSet.setFlag.value : nil
    self.transferRate = accountSet.hasTransferRate ? accountSet.transferRate.value : nil
    self.tickSize = accountSet.hasTickSize ? UInt8(accountSet.tickSize.value) : nil
  }
}

// TODO(keefertaylor): X-Address
public struct XRPAccountDelete: Equatable {
  public let destination: Address
  public let destinationTag: UInt32?
}

internal extension XRPAccountDelete {
  init(accountDelete: Org_Xrpl_Rpc_V1_AccountDelete) {
    self.destination = accountDelete.destination.value.address
    self.destinationTag = accountDelete.hasDestinationTag ? accountDelete.destinationTag.value : nil
  }
}

public struct XRPCheckCancel: Equatable {
  public let checkID: Data
}

internal extension XRPCheckCancel {
  init(checkCancel: Org_Xrpl_Rpc_V1_CheckCancel) {
    self.checkID = checkCancel.checkID.value
  }
}

public struct XRPCheckCash: Equatable {
  public let checkID: Data

  // Mutually exclusive, only one field will be set.
  public let amount: XRPCurrencyAmount?
  public let deliverMin: XRPCurrencyAmount?
}

internal extension XRPCheckCash {
  init?(checkCash: Org_Xrpl_Rpc_V1_CheckCash) {
    self.checkID = checkCash.checkID.value

    switch checkCash.amountOneof {
    case .amount(let amount):
      guard let currencyAmount = XRPCurrencyAmount(currencyAmount: amount.value) else {
        return nil
      }
      self.amount = currencyAmount
      self.deliverMin = nil
    case .deliverMin(let deliverMin):
      guard let currencyAmount = XRPCurrencyAmount(currencyAmount: deliverMin.value) else {
        return nil
      }
      self.amount = nil
      self.deliverMin = currencyAmount
    case .none:
      return nil
    }
  }
}

// TODO(keefertaylor): X-Address
public struct XRPCheckCreate: Equatable {
  public let destination: Address
  public let destinationTag: UInt32?
  public let expiration: TimeInterval?
  public let invoiceID: Data?
  public let sendMax: XRPCurrencyAmount
}

internal extension XRPCheckCreate {
  init?(checkCreate: Org_Xrpl_Rpc_V1_CheckCreate) {
    self.destination = checkCreate.destination.value.address
    self.destinationTag = checkCreate.hasDestinationTag ? checkCreate.destinationTag.value : nil
    self.expiration = checkCreate.hasExpiration ? TimeInterval(checkCreate.expiration.value) : nil
    self.invoiceID = checkCreate.hasInvoiceID ? checkCreate.invoiceID.value : nil

    guard let sendMax = XRPCurrencyAmount(currencyAmount: checkCreate.sendMax.value) else {
      return nil
    }
    self.sendMax = sendMax
  }
}

public struct XRPDepositPreauth: Equatable {
  // Mutually exclusive, only one of the following fields is set.
  public let authorize: Address?
  public let unauthorize: Address?
}
extension XRPDepositPreauth {
  init?(depositPreauth: Org_Xrpl_Rpc_V1_DepositPreauth) {
    switch depositPreauth.authorizationOneof {
    case .authorize(let authorize):
      self.authorize = authorize.value.address
      self.unauthorize = nil
    case .unauthorize(let unauthorize):
      self.authorize = nil
      self.unauthorize = unauthorize.value.address
    case .none:
      return nil
    }
  }
}

public struct XRPEscrowCancel: Equatable {
  public let offerSequence: UInt32
  public let owner: Address
}

internal extension XRPEscrowCancel {
  init(escrowCancel: Org_Xrpl_Rpc_V1_EscrowCancel) {
    self.offerSequence = escrowCancel.offerSequence.value
    self.owner = escrowCancel.owner.value.address
  }
}

// TODO(keefertaylor): X-Address
public struct XRPEscrowCreate: Equatable {
  public let amount: XRPCurrencyAmount
  public let cancelAfter: TimeInterval?
  public let condition: Data?
  public let destination: Address
  public let destinationTag: UInt32?
  public let finishAfter: TimeInterval?
}

internal extension XRPEscrowCreate {
  init?(escrowCreate: Org_Xrpl_Rpc_V1_EscrowCreate) {
    guard let amount = XRPCurrencyAmount(currencyAmount: escrowCreate.amount.value) else {
      return nil
    }
    self.amount = amount
    self.cancelAfter = escrowCreate.hasCancelAfter ? TimeInterval(escrowCreate.cancelAfter.value) : nil
    self.condition = escrowCreate.hasCondition ? escrowCreate.condition.value : nil
    self.destination = escrowCreate.destination.value.address
    self.destinationTag = escrowCreate.hasDestinationTag ? escrowCreate.destinationTag.value : nil
    self.finishAfter = escrowCreate.hasFinishAfter ? TimeInterval(escrowCreate.finishAfter.value) : nil
  }
}

public struct XRPEscrowFinish: Equatable {
  public let condition: Data?
  public let fulfillment: Data?
  public let offerSequence: UInt32
  public let owner: Address
}

internal extension XRPEscrowFinish {
  init(escrowFinish: Org_Xrpl_Rpc_V1_EscrowFinish) {
    self.condition = escrowFinish.hasCondition ? escrowFinish.condition.value : nil
    self.fulfillment = escrowFinish.hasFulfillment ? escrowFinish.fulfillment.value : nil
    self.offerSequence = escrowFinish.offerSequence.value
    self.owner = escrowFinish.owner.value.address
  }
}

public struct XRPOfferCancel: Equatable {
  public let offerSequence: UInt32
}

internal extension XRPOfferCancel {
  init(offerCancel: Org_Xrpl_Rpc_V1_OfferCancel) {
    self.offerSequence = offerCancel.offerSequence.value
  }
}

public struct XRPOfferCreate: Equatable {
  public let expiration: TimeInterval?
  public let offerSequence: UInt32?
  public let takerGets: XRPCurrencyAmount
  public let takerPays: XRPCurrencyAmount
}

internal extension XRPOfferCreate {
  init?(offerCreate: Org_Xrpl_Rpc_V1_OfferCreate) {
    self.expiration = offerCreate.hasExpiration ? TimeInterval(offerCreate.expiration.value) : nil
    self.offerSequence = offerCreate.hasOfferSequence ? offerCreate.offerSequence.value : nil

    guard
      let takerGets = XRPCurrencyAmount(currencyAmount: offerCreate.takerGets.value),
      let takerPays = XRPCurrencyAmount(currencyAmount: offerCreate.takerPays.value)
    else {
      return nil
    }
    self.takerGets = takerGets
    self.takerPays = takerPays
  }
}

// TODO(keefertaylor): X-Address
public struct XRPPayment: Equatable {
  public let amount: XRPCurrencyAmount
  public let destination: Address
  public let destinationTag: UInt32?
  public let deliverMin: XRPCurrencyAmount?
  public let invoiceID: Data?
  public let paths: [XRPPath]?
  public let sendMax: XRPCurrencyAmount?
}

internal extension XRPPayment {
  init?(payment: Org_Xrpl_Rpc_V1_Payment) {
    guard let amount = XRPCurrencyAmount(currencyAmount: payment.amount.value) else {
      return nil
    }
    self.amount = amount
    self.destination = payment.destination.value.address
    self.destinationTag = payment.hasDestinationTag ? payment.destinationTag.value : nil

    // If the deliverMin field is set, it must be able to be transformed into a XRPCurrencyAmount.
    if payment.hasDeliverMin {
      if let deliverMin = XRPCurrencyAmount(currencyAmount: payment.deliverMin.value) {
        self.deliverMin = deliverMin
      } else {
        return nil
      }
    } else {
      self.deliverMin = nil
    }

    self.invoiceID = payment.hasInvoiceID ? payment.invoiceID.value : nil
    self.paths = payment.paths.count > 0 ? payment.paths.map { path in XRPPath(path: path) } : nil

    // If the sendMax field is set, it must be able to be transformed into a XRPCurrencyAmount.
    if payment.hasSendMax {
      if let sendMax = XRPCurrencyAmount(currencyAmount: payment.sendMax.value) {
        self.sendMax = sendMax
      } else {
        return nil
      }
    } else {
      self.sendMax = nil
    }
  }
}

public struct XRPPath: Equatable {
  public let pathElements: [XRPPathElement]
}

internal extension XRPPath {
  init(path: Org_Xrpl_Rpc_V1_Payment.Path) {
    self.pathElements = path.elements.map { pathElement in XRPPathElement(pathElement: pathElement) }
  }
}

public struct XRPPathElement: Equatable {
  public let account: Address?
  public let currency: XRPCurrency?
  public let issuer: Address?
}

internal extension XRPPathElement {
  init(pathElement: Org_Xrpl_Rpc_V1_Payment.PathElement) {
    self.account = pathElement.hasAccount ? pathElement.account.address : nil
    self.currency = pathElement.hasCurrency ? XRPCurrency(currency: pathElement.currency) : nil
    self.issuer = pathElement.hasIssuer ? pathElement.issuer.address : nil
  }
}

public struct XRPPaymentChannelClaim: Equatable {
  public let amount: XRPCurrencyAmount?
  public let balance: XRPCurrencyAmount?
  public let channel: Data
  public let paymentChannelSignature: Data?
  public let publicKey: Data?
}

internal extension XRPPaymentChannelClaim {
  init?(paymentChannelClaim: Org_Xrpl_Rpc_V1_PaymentChannelClaim) {
    // If the amount field is set, it must be able to be transformed into a XRPCurrencyAmount.
    if paymentChannelClaim.hasAmount {
      if let amount = XRPCurrencyAmount(currencyAmount: paymentChannelClaim.amount.value) {
        self.amount = amount
      } else {
        return nil
      }
    } else {
      self.amount = nil
    }

    // If the balance field is set, it must be able to be transformed into a XRPCurrencyAmount.
    if paymentChannelClaim.hasBalance {
      if let balance = XRPCurrencyAmount(currencyAmount: paymentChannelClaim.balance.value) {
        self.balance = balance
      } else {
        return nil
      }
    } else {
      self.balance = nil
    }

    self.channel = paymentChannelClaim.channel.value
    self.paymentChannelSignature =
      paymentChannelClaim.hasPaymentChannelSignature ? paymentChannelClaim.paymentChannelSignature.value : nil
    self.publicKey = paymentChannelClaim.hasPublicKey ? paymentChannelClaim.publicKey.value : nil
  }
}

// TODO(keefertaylor): X-Address
public struct XRPPaymentChannelCreate: Equatable {
  public let amount: XRPCurrencyAmount
  public let cancelAfter: TimeInterval?
  public let destination: Address
  public let destinationTag: UInt32?
  public let publicKey: Data
  public let settleDelay: UInt32
}

// TODO(keefer): TimeInterval is an okay type?
internal extension XRPPaymentChannelCreate {
  init?(paymentChannelCreate: Org_Xrpl_Rpc_V1_PaymentChannelCreate) {
    guard let amount = XRPCurrencyAmount(currencyAmount: paymentChannelCreate.amount.value) else {
      return nil
    }
    self.amount = amount
    self.cancelAfter = paymentChannelCreate.hasCancelAfter ? TimeInterval(paymentChannelCreate.cancelAfter.value) : nil
    self.destination = paymentChannelCreate.destination.value.address
    self.destinationTag = paymentChannelCreate.hasDestinationTag ? paymentChannelCreate.destinationTag.value : nil
    self.publicKey = paymentChannelCreate.publicKey.value
    self.settleDelay = paymentChannelCreate.settleDelay.value
  }
}

public struct XRPPaymentChannelFund: Equatable {
  public let amount: XRPCurrencyAmount
  public let channel: Data
  public let expiration: TimeInterval?
}

internal extension XRPPaymentChannelFund {
  init?(paymentChannelFund: Org_Xrpl_Rpc_V1_PaymentChannelFund) {
    guard let amount = XRPCurrencyAmount(currencyAmount: paymentChannelFund.amount.value) else {
      return nil
    }
    self.amount = amount
    self.channel = paymentChannelFund.channel.value
    self.expiration = paymentChannelFund.hasExpiration ? TimeInterval(paymentChannelFund.expiration.value) : nil
  }
}

public struct XRPSetRegularKey: Equatable {
  public let regularKey: Address?
}

internal extension XRPSetRegularKey {
  init(setRegularKey: Org_Xrpl_Rpc_V1_SetRegularKey) {
    self.regularKey = setRegularKey.hasRegularKey ? setRegularKey.regularKey.value.address : nil
  }
}

public struct XRPSignerEntry: Equatable {
  public let account: Address
  public let signerWeight: UInt16
}

internal extension XRPSignerEntry {
  init?(signerEntry: Org_Xrpl_Rpc_V1_SignerEntry) {
    self.account = signerEntry.account.value.address
    self.signerWeight = UInt16(signerEntry.signerWeight.value)
  }
}

public struct XRPSignerListSet: Equatable {
  public let signerQuorum: UInt32
  public let signerEntries: [XRPSignerEntry]?
}

internal extension XRPSignerListSet {
  init?(signerListSet: Org_Xrpl_Rpc_V1_SignerListSet) {
    self.signerQuorum = signerListSet.signerQuorum.value

    if signerListSet.signerEntries.count > 0 {
      do {
        self.signerEntries = try signerListSet.signerEntries.map { signerEntry in
          guard let signerEntry = XRPSignerEntry(signerEntry: signerEntry) else {
            throw XRPLedgerError.malformedResponse("Couldn't formulate signer entry")
          }
          return signerEntry
        }
      } catch {
        return nil
      }
    } else {
      signerEntries = nil
    }
  }
}

public struct XRPTrustSet: Equatable {
  public let limitAmount: XRPCurrencyAmount
  public let qualityIn: UInt32?
  public let qualityOut: UInt32?
}

internal extension XRPTrustSet {
  init?(trustSet: Org_Xrpl_Rpc_V1_TrustSet) {
    guard let limitAmount = XRPCurrencyAmount(currencyAmount: trustSet.limitAmount.value) else {
      return nil
    }
    self.limitAmount = limitAmount
    self.qualityIn = trustSet.hasQualityIn ? trustSet.qualityIn.value : nil
    self.qualityOut = trustSet.hasQualityOut ? trustSet.qualityOut.value : nil
  }
}

public struct XRPCurrencyAmount: Equatable {
  // Mutually exclusive, only one of the below fields is set.
  public let drops: UInt64?
  public let issuedCurrency: XRPIssuedCurrency?
}

internal extension XRPCurrencyAmount {
  init?(currencyAmount: Org_Xrpl_Rpc_V1_CurrencyAmount) {
    switch currencyAmount.amount {
    case .issuedCurrencyAmount(let issuedCurrency):
      guard let issuedCurrency = XRPIssuedCurrency(issuedCurrency: issuedCurrency) else {
        return nil
      }
      self.issuedCurrency = issuedCurrency
      self.drops = nil
    case .xrpAmount(let dropsAmount):
      self.drops = dropsAmount.drops
      self.issuedCurrency = nil
    case .none:
      return nil
    }
  }
}

public struct XRPIssuedCurrency: Equatable {
  public let currency: XRPCurrency
  public let value: BigInt
  public let issuer: Address
}

internal extension XRPIssuedCurrency {
  init?(issuedCurrency: Org_Xrpl_Rpc_V1_IssuedCurrencyAmount) {
    guard let value = BigInt(issuedCurrency.value) else {
      return nil
    }

    self.currency = XRPCurrency(currency: issuedCurrency.currency)
    self.value = value
    self.issuer = issuedCurrency.issuer.address
  }
}

public struct XRPCurrency: Equatable {
  public let name: String
  public let code: Data
}

internal extension XRPCurrency {
  init(currency: Org_Xrpl_Rpc_V1_Currency) {
    self.name = currency.name
    self.code = currency.code
  }
}
