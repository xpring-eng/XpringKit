import XCTest
@testable import XpringKit

/// Tests conversion of XRPL Transaction Type protocol buffers to native Swift structs.
final class TransactionTypeProtobufConversionTests: XCTestCase {

  // MARK: - Org_Xrpl_Rpc_V1_AccountSet

  func testConvertAccountSetAllFields() {
    // GIVEN an AccountSet protocol buffer with all fields set.
    let accountSetProto = Org_Xrpl_Rpc_V1_AccountSet.testAccountSetAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpAccountSet: XRPAccountSet = XRPAccountSet(accountSet: accountSetProto)!

    // THEN the protocol buffer converted as expected.
    XCTAssertEqual(xrpAccountSet.clearFlag, accountSetProto.clearFlag_p.value)
    XCTAssertEqual(xrpAccountSet.domain, accountSetProto.domain.value)
    XCTAssertEqual(xrpAccountSet.emailHash, accountSetProto.emailHash.value)
    XCTAssertEqual(xrpAccountSet.messageKey, accountSetProto.messageKey.value)
    XCTAssertEqual(xrpAccountSet.setFlag, accountSetProto.setFlag.value)
    XCTAssertEqual(xrpAccountSet.transferRate, accountSetProto.transferRate.value)
    XCTAssertEqual(xrpAccountSet.tickSize, accountSetProto.tickSize.value)
  }

  func testConvertAccountSetOneField() {
    // GIVEN an AccountSet protocol buffer with one field set.
    let accountSetProto = Org_Xrpl_Rpc_V1_AccountSet.testAccountSetOneField

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpAccountSet: XRPAccountSet = XRPAccountSet(accountSet: accountSetProto)!

    // THEN the protocol buffer converted as expected.
    XCTAssertEqual(xrpAccountSet.clearFlag, accountSetProto.clearFlag_p.value)
    XCTAssertNil(xrpAccountSet.domain)
    XCTAssertNil(xrpAccountSet.emailHash)
    XCTAssertNil(xrpAccountSet.messageKey)
    XCTAssertNil(xrpAccountSet.setFlag)
    XCTAssertNil(xrpAccountSet.transferRate)
    XCTAssertNil(xrpAccountSet.tickSize)
  }

  // MARK: - Org_Xrpl_Rpc_V1_AccountDelete

  func testConvertAccountDeleteAllFields() {
    // GIVEN an AccountDelete protocol buffer with all fields set.
    let accountDelete = Org_Xrpl_Rpc_V1_AccountDelete.testAccountDeleteAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpAccountDelete = XRPAccountDelete(accountDelete: accountDelete, xrplNetwork: XRPLNetwork.test)

    // THEN the AccountDelete converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: accountDelete.destination.value.address,
      tag: accountDelete.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(xrpAccountDelete!.destinationXAddress, expectedXAddress)
  }

  func testConvertAccountDeleteNoTag() {
    // GIVEN an AccountDelete protocol buffer with only destination field set.
    let accountDelete = Org_Xrpl_Rpc_V1_AccountDelete.testAccountDeleteNoTag

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpAccountDelete = XRPAccountDelete(accountDelete: accountDelete, xrplNetwork: XRPLNetwork.test)

    // THEN the AccountDelete converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: accountDelete.destination.value.address,
      tag: accountDelete.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(xrpAccountDelete!.destinationXAddress, expectedXAddress)
  }

  func testConvertAccountDeleteNoFields() {
    // GIVEN an AccountDelete protocol buffer missing the destination field.
    let accountDelete = Org_Xrpl_Rpc_V1_AccountDelete.testAccountDeleteNoFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpAccountDelete = XRPAccountDelete(accountDelete: accountDelete, xrplNetwork: XRPLNetwork.test)

    // THEN the result is nil.
    XCTAssertNil(xrpAccountDelete)
  }

  // MARK: - Org_Xrpl_Rpc_V1_CheckCancel

  func testConvertCheckCancelAllFields() {
    // GIVEN a CheckCancel protocol buffer.
    let checkCancel = Org_Xrpl_Rpc_V1_CheckCancel.testCheckCancelAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCancel = XRPCheckCancel(checkCancel: checkCancel)

    // THEN the CheckCancel converted as expected.
    XCTAssertEqual(
      xrpCheckCancel?.checkId,
      String(data: checkCancel.checkID.value, encoding: .utf8)
    )
  }

  func testConvertCheckCancelMissingCheckId() {
    // GIVEN a CheckCancel protocol buffer without a checkId.
    let checkCancel = Org_Xrpl_Rpc_V1_CheckCancel.testCheckCancelMissingCheckId

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCancel = XRPCheckCancel(checkCancel: checkCancel)

    // THEN the result is nil.
    XCTAssertNil(xrpCheckCancel)
  }

  // MARK: - Org_Xrpl_Rpc_V1_CheckCash

  func testConvertCheckCashWithAmountField() {
    // GIVEN a valid CheckCash protocol buffer with amount field set.
    let checkCash = Org_Xrpl_Rpc_V1_CheckCash.testCheckCashWithAmount

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCash = XRPCheckCash(checkCash: checkCash)

    // THEN the CheckCash converted as expected.
    XCTAssertEqual(
      xrpCheckCash?.checkId,
      String(data: checkCash.checkID.value, encoding: .utf8)
    )
    XCTAssertEqual(xrpCheckCash?.amount, XRPCurrencyAmount(currencyAmount: checkCash.amount.value))
    XCTAssertNil(xrpCheckCash?.deliverMin)
  }

  func testConvertCheckCashWithDeliverMinField() {
    // GIVEN a valid CheckCash protocol buffer with deliverMin field set.
    let checkCash = Org_Xrpl_Rpc_V1_CheckCash.testCheckCashWithDeliverMin

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCash = XRPCheckCash(checkCash: checkCash)

    // THEN the CheckCash converted as expected.
    XCTAssertEqual(
      xrpCheckCash?.checkId,
      String(data: checkCash.checkID.value, encoding: .utf8)
    )
    XCTAssertNil(xrpCheckCash?.amount)
    XCTAssertEqual(xrpCheckCash?.deliverMin, XRPCurrencyAmount(currencyAmount: checkCash.deliverMin.value))
  }

  func testConvertCheckCashMissingCheckId() {
    // GIVEN a valid CheckCash protocol buffer missing the checkId field.
    let checkCash = Org_Xrpl_Rpc_V1_CheckCash.testCheckCashMissingCheckId

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCash = XRPCheckCash(checkCash: checkCash)

    // THEN the result is nil.
    XCTAssertNil(xrpCheckCash)
  }

  // MARK: - Org_Xrpl_Rpc_V1_CheckCreate

  func testConvertCheckCreateAllfields() {
    // GIVEN a CheckCreate protocol buffer with all fields set.
    let checkCreate = Org_Xrpl_Rpc_V1_CheckCreate.testCheckCreateAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCreate = XRPCheckCreate(checkCreate: checkCreate, xrplNetwork: XRPLNetwork.test)

    // THEN the CheckCreate converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: checkCreate.destination.value.address,
      tag: checkCreate.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(xrpCheckCreate?.destinationXAddress, expectedXAddress)
    XCTAssertEqual(
      xrpCheckCreate?.sendMax,
      XRPCurrencyAmount(currencyAmount: checkCreate.sendMax.value)
    )
    XCTAssertEqual(xrpCheckCreate?.expiration, checkCreate.expiration.value)
    XCTAssertEqual(
      xrpCheckCreate?.invoiceId,
      String(data: checkCreate.invoiceID.value, encoding: .utf8)
    )
  }

  func testConvertCheckCreateMandatoryFields() {
    // GIVEN a CheckCreate protocol buffer with only mandatory fields set.
    let checkCreate = Org_Xrpl_Rpc_V1_CheckCreate.testCheckCreateMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCreate = XRPCheckCreate(checkCreate: checkCreate, xrplNetwork: XRPLNetwork.test)

    // THEN the CheckCreate converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: checkCreate.destination.value.address,
      tag: checkCreate.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(xrpCheckCreate?.destinationXAddress, expectedXAddress)
    XCTAssertEqual(
      xrpCheckCreate?.sendMax,
      XRPCurrencyAmount(currencyAmount: checkCreate.sendMax.value)
    )
    XCTAssertNil(xrpCheckCreate?.expiration)
    XCTAssertNil(xrpCheckCreate?.invoiceId)
  }

  func testConvertCheckCreateMissingDestination() {
    // GIVEN an invalid CheckCreate protocol buffer missing the destination field.
    let checkCreate = Org_Xrpl_Rpc_V1_CheckCreate.testCheckCreateMissingDestination

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpCheckCreate = XRPCheckCreate(checkCreate: checkCreate, xrplNetwork: XRPLNetwork.test)

    // THEN the result is nil.
    XCTAssertNil(xrpCheckCreate)
  }

  // MARK: - Org_Xrpl_Rpc_V1_DepositPreauth

  func testConvertDepositPreauthWithAuthorize() {
    // GIVEN a DepositPreauth protocol buffer with authorize field set.
    let depositPreauth = Org_Xrpl_Rpc_V1_DepositPreauth.testDepositPreauthWithAuthorize

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpDepositPreauth = XRPDepositPreauth(
      depositPreauth: depositPreauth,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the DepositPreauth converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: depositPreauth.authorize.value.address,
      isTest: true
    )
    XCTAssertEqual(xrpDepositPreauth?.authorizeXAddress, expectedXAddress)
  }

  func testConvertDepositPreauthWithUnauthorize() {
    // GIVEN a DepositPreauth protocol buffer with unauthorize field set.
    let depositPreauth = Org_Xrpl_Rpc_V1_DepositPreauth.testDepositPreauthWithUnauthorize

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpDepositPreauth = XRPDepositPreauth(
      depositPreauth: depositPreauth,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the DepositPreauth converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: depositPreauth.unauthorize.value.address,
      isTest: true
    )
    XCTAssertEqual(xrpDepositPreauth?.unauthorizeXAddress, expectedXAddress)
  }

  func testConvertDepositPreauthNoFields() {
    // GIVEN a DepositPreauth protocol buffer with no fields set.
    let depositPreauth = Org_Xrpl_Rpc_V1_DepositPreauth.testDepositPreauthWithNoFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpDepositPreauth = XRPDepositPreauth(
      depositPreauth: depositPreauth,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the DepositPreauth converts to nil.
    XCTAssertNil(xrpDepositPreauth)
  }

  // MARK: - Org_Xrpl_Rpc_V1_EscrowCancel

  func testConvertEscrowCancelAllFields() {
    // GIVEN an EscrowCancel protocol buffer with all fields set.
    let escrowCancel = Org_Xrpl_Rpc_V1_EscrowCancel.testEscrowCancelAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowCancel = XRPEscrowCancel(
      escrowCancel: escrowCancel,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the EscrowCancel converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: escrowCancel.owner.value.address,
      isTest: true
    )
    XCTAssertEqual(xrpEscrowCancel?.ownerXAddress, expectedXAddress)
    XCTAssertEqual(xrpEscrowCancel?.offerSequence, escrowCancel.offerSequence.value)
  }

  func testConvertEscrowCancelMissingOwner() {
    // GIVEN an EscrowCancel protocol buffer missing required fields.
    let escrowCancel = Org_Xrpl_Rpc_V1_EscrowCancel.testEscrowCancelMissingOwner

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowCancel = XRPEscrowCancel(
      escrowCancel: escrowCancel,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the result is nil.
    XCTAssertNil(xrpEscrowCancel)
  }

  // MARK: - Org_Xrpl_Rpc_V1_EscrowCreate

  func testConvertEscrowCreateAllFields() {
    // GIVEN an EscrowCreate protocol buffer with all fields set.
    let escrowCreate = Org_Xrpl_Rpc_V1_EscrowCreate.testEscrowCreateAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowCreate = XRPEscrowCreate(escrowCreate: escrowCreate, xrplNetwork: XRPLNetwork.test)

    // THEN the EscrowCreate converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: escrowCreate.destination.value.address,
      tag: escrowCreate.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(
      xrpEscrowCreate?.amount,
      XRPCurrencyAmount(currencyAmount: escrowCreate.amount.value)
    )
    XCTAssertEqual(xrpEscrowCreate?.destinationXAddress, expectedXAddress)
    XCTAssertEqual(xrpEscrowCreate?.cancelAfter, escrowCreate.cancelAfter.value)
    XCTAssertEqual(xrpEscrowCreate?.finishAfter, escrowCreate.finishAfter.value)
    XCTAssertEqual(xrpEscrowCreate?.condition, String(decoding: escrowCreate.condition.value, as: UTF8.self))
  }

  func testConvertEscrowCreateMandatoryFields() {
    // GIVEN an EscrowCreate protocol buffer with only mandatory fields set.
    let escrowCreate = Org_Xrpl_Rpc_V1_EscrowCreate.testEscrowCreateMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowCreate = XRPEscrowCreate(escrowCreate: escrowCreate, xrplNetwork: XRPLNetwork.test)

    // THEN the EscrowCreate converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: escrowCreate.destination.value.address,
      tag: escrowCreate.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(
      xrpEscrowCreate?.amount,
      XRPCurrencyAmount(currencyAmount: escrowCreate.amount.value)
    )
    XCTAssertEqual(xrpEscrowCreate?.destinationXAddress, expectedXAddress)
    XCTAssertNil(xrpEscrowCreate?.cancelAfter)
    XCTAssertNil(xrpEscrowCreate?.finishAfter)
    XCTAssertNil(xrpEscrowCreate?.condition)
  }

  func testConvertEscrowCreateMissingDestination() {
    // GIVEN an EscrowCreate protocol buffer that's missing a mandatory field.
    let escrowCreate = Org_Xrpl_Rpc_V1_EscrowCreate.testEscrowCreateMissingDestination

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowCreate = XRPEscrowCreate(escrowCreate: escrowCreate, xrplNetwork: XRPLNetwork.test)

    // THEN the result is nil.
    XCTAssertNil(xrpEscrowCreate)
  }

  // MARK: - Org_Xrpl_Rpc_V1_EscrowFinish

  func testConvertEscrowFinishAllFields() {
    // GIVEN an EscrowFinish protocol buffer with all fields set.
    let escrowFinish = Org_Xrpl_Rpc_V1_EscrowFinish.testEscrowFinishAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowFinish = XRPEscrowFinish(
      escrowFinish: escrowFinish,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the EscrowFinish converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: escrowFinish.owner.value.address,
      isTest: true
    )

    XCTAssertEqual(xrpEscrowFinish?.ownerXAddress, expectedXAddress)
    XCTAssertEqual(xrpEscrowFinish?.offerSequence, escrowFinish.offerSequence.value)

    XCTAssertEqual(
      xrpEscrowFinish?.condition,
      String(decoding: escrowFinish.condition.value, as: UTF8.self)
    )
    XCTAssertEqual(
      xrpEscrowFinish?.fulfillment,
      String(decoding: escrowFinish.fulfillment.value, as: UTF8.self)
    )
  }

  func testConvertEscrowFinishMandatoryFields() {
    // GIVEN an EscrowFinish protocol buffer with all fields set.
    let escrowFinish = Org_Xrpl_Rpc_V1_EscrowFinish.testEscrowFinishMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowFinish = XRPEscrowFinish(
      escrowFinish: escrowFinish,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the EscrowFinish converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: escrowFinish.owner.value.address,
      isTest: true
    )

    XCTAssertEqual(xrpEscrowFinish?.ownerXAddress, expectedXAddress)
    XCTAssertEqual(xrpEscrowFinish?.offerSequence, escrowFinish.offerSequence.value)

    XCTAssertNil(xrpEscrowFinish?.condition)
    XCTAssertNil(xrpEscrowFinish?.fulfillment)
  }

  func testConvertEscrowFinishMissingOwner() {
    // GIVEN an EscrowFinish protocol buffer with all fields set.
    let escrowFinish = Org_Xrpl_Rpc_V1_EscrowFinish.testEscrowFinishMissingOwner

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpEscrowFinish = XRPEscrowFinish(
      escrowFinish: escrowFinish,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the result is nil.
    XCTAssertNil(xrpEscrowFinish)
  }

  // MARK: - Org_Xrpl_Rpc_V1_OfferCancel

  func testConvertOfferCancelFieldSet() {
    // GIVEN an OfferCancel protocol buffer with offerSequence field set.
    let offerCancel = Org_Xrpl_Rpc_V1_OfferCancel.testOfferCancelFieldSet

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpOfferCancel = XRPOfferCancel(offerCancel: offerCancel)

    // THEN the OfferCancel converted as expected.
    XCTAssertEqual(xrpOfferCancel?.offerSequence, offerCancel.offerSequence.value)
  }

  func testConvertOfferCancelMissingOfferSequence() {
    // GIVEN an OfferCancel protocol buffer missing the offerSequence field.
    let offerCancel = Org_Xrpl_Rpc_V1_OfferCancel.testOfferCancelMissingOfferSequence

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpOfferCancel = XRPOfferCancel(offerCancel: offerCancel)

    // THEN the result is nil.
    XCTAssertNil(xrpOfferCancel)
  }

  // MARK: - Org_Xrpl_Rpc_V1_OfferCreate

  func testConvertOfferCreateAllFields() {
    // GIVEN an OfferCreate protocol buffer with all fields set.
    let offerCreate = Org_Xrpl_Rpc_V1_OfferCreate.testOfferCreateAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpOfferCreate = XRPOfferCreate(offerCreate: offerCreate)

    // THEN the OfferCreate converted as expected.
    XCTAssertEqual(
      xrpOfferCreate?.takerGets,
      XRPCurrencyAmount(currencyAmount: offerCreate.takerGets.value)
    )
    XCTAssertEqual(
      xrpOfferCreate?.takerPays,
      XRPCurrencyAmount(currencyAmount: offerCreate.takerPays.value)
    )
    XCTAssertEqual(xrpOfferCreate?.expiration, offerCreate.expiration.value)
    XCTAssertEqual(xrpOfferCreate?.offerSequence, offerCreate.offerSequence.value)
  }

  func testConvertOfferCreateMandatoryFields() {
    // GIVEN an OfferCreate protocol buffer with only mandatory fields set.
    let offerCreate = Org_Xrpl_Rpc_V1_OfferCreate.testOfferCreateMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpOfferCreate = XRPOfferCreate(offerCreate: offerCreate)

    // THEN the OfferCreate converted as expected.
    XCTAssertEqual(
      xrpOfferCreate?.takerGets,
      XRPCurrencyAmount(currencyAmount: offerCreate.takerGets.value)
    )
    XCTAssertEqual(
      xrpOfferCreate?.takerPays,
      XRPCurrencyAmount(currencyAmount: offerCreate.takerPays.value)
    )
    XCTAssertNil(xrpOfferCreate?.expiration)
    XCTAssertNil(xrpOfferCreate?.offerSequence)
  }

  func testConvertOfferCreateMissingTakerGets() {
    // GIVEN an OfferCreate protocol buffer missing a required field.
    let offerCreate = Org_Xrpl_Rpc_V1_OfferCreate.testOfferCreateMissingTakerGets

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpOfferCreate = XRPOfferCreate(offerCreate: offerCreate)

    // THEN the result is nil.
    XCTAssertNil(xrpOfferCreate)
  }

  // MARK: - Org_Xrpl_Rpc_V1_PaymentChannelClaim

  func testPaymentChannelClaimAllFields() {
    // GIVEN a PaymentChannelClaim protocol buffer with all fields set.
    let paymentChannelClaim = Org_Xrpl_Rpc_V1_PaymentChannelClaim.testPaymentChannelClaimAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelClaim = XRPPaymentChannelClaim(paymentChannelClaim: paymentChannelClaim)

    // THEN the PaymentChannelClaim converted as expected.
    XCTAssertEqual(
      xrpPaymentChannelClaim?.channel,
      String(decoding: paymentChannelClaim.channel.value, as: UTF8.self)
    )
    XCTAssertEqual(
      xrpPaymentChannelClaim?.balance,
      XRPCurrencyAmount(currencyAmount: paymentChannelClaim.balance.value)
    )
    XCTAssertEqual(
      xrpPaymentChannelClaim?.amount,
      XRPCurrencyAmount(currencyAmount: paymentChannelClaim.amount.value)
    )
    XCTAssertEqual(
      xrpPaymentChannelClaim?.signature,
      String(decoding: paymentChannelClaim.paymentChannelSignature.value, as: UTF8.self)
    )
    XCTAssertEqual(
      xrpPaymentChannelClaim?.publicKey,
      String(decoding: paymentChannelClaim.publicKey.value, as: UTF8.self)
    )
  }

  func testPaymentChannelClaimMandatoryFields() {
    // GIVEN a PaymentChannelClaim protocol buffer with only mandatory fields set.
    let paymentChannelClaim = Org_Xrpl_Rpc_V1_PaymentChannelClaim.testPaymentChannelClaimMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelClaim = XRPPaymentChannelClaim(paymentChannelClaim: paymentChannelClaim)

    // THEN the PaymentChannelClaim converted as expected.
    XCTAssertEqual(
      xrpPaymentChannelClaim?.channel,
      String(decoding: paymentChannelClaim.channel.value, as: UTF8.self)
    )
    XCTAssertNil(xrpPaymentChannelClaim?.balance)
    XCTAssertNil(xrpPaymentChannelClaim?.amount)
    XCTAssertNil(xrpPaymentChannelClaim?.signature)
    XCTAssertNil(xrpPaymentChannelClaim?.publicKey)
  }

  func testPaymentChannelClaimMissingChannel() {
    // GIVEN a PaymentChannelClaim protocol buffer missing the channel field.
    let paymentChannelClaim = Org_Xrpl_Rpc_V1_PaymentChannelClaim.testPaymentChannelClaimMissingChannel

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelClaim = XRPPaymentChannelClaim(paymentChannelClaim: paymentChannelClaim)

    // THEN the result is nil.
    XCTAssertNil(xrpPaymentChannelClaim)
  }

  // MARK: - Org_Xrpl_Rpc_V1_PaymentChannelCreate

  func testConvertPaymentChannelCreateAllFields() {
    // GIVEN a PaymentChannelCreate protocol buffer with all fields set.
    let paymentChannelCreate = Org_Xrpl_Rpc_V1_PaymentChannelCreate.testPaymentChannelCreateAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelCreate = XRPPaymentChannelCreate(
      paymentChannelCreate: paymentChannelCreate,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the PaymentChannelCreate converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: paymentChannelCreate.destination.value.address,
      tag: paymentChannelCreate.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.amount,
      XRPCurrencyAmount(currencyAmount: paymentChannelCreate.amount.value)
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.destinationXAddress,
      expectedXAddress
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.settleDelay,
      paymentChannelCreate.settleDelay.value
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.publicKey,
      String(decoding: paymentChannelCreate.publicKey.value, as: UTF8.self)
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.cancelAfter,
      paymentChannelCreate.cancelAfter.value
    )
  }

  func testConvertPaymentChannelCreateMandatoryFields() {
    // GIVEN a PaymentChannelCreate protocol buffer with mandatory fields set.
    let paymentChannelCreate = Org_Xrpl_Rpc_V1_PaymentChannelCreate.testPaymentChannelCreateMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelCreate = XRPPaymentChannelCreate(
      paymentChannelCreate: paymentChannelCreate,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the PaymentChannelCreate converted as expected.
    let expectedXAddress = Utils.encode(
      classicAddress: paymentChannelCreate.destination.value.address,
      tag: paymentChannelCreate.destinationTag.value,
      isTest: true
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.amount,
      XRPCurrencyAmount(currencyAmount: paymentChannelCreate.amount.value)
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.destinationXAddress,
      expectedXAddress
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.settleDelay,
      paymentChannelCreate.settleDelay.value
    )
    XCTAssertEqual(
      xrpPaymentChannelCreate?.publicKey,
      String(decoding: paymentChannelCreate.publicKey.value, as: UTF8.self)
    )
    XCTAssertNil(xrpPaymentChannelCreate?.cancelAfter)
  }

  func testConvertPaymentChannelCreateMissingDestination() {
    // GIVEN a PaymentChannelCreate protocol buffer missing the destination field.
    let paymentChannelCreate = Org_Xrpl_Rpc_V1_PaymentChannelCreate.testPaymentChannelCreateMissingDest

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelCreate = XRPPaymentChannelCreate(
      paymentChannelCreate: paymentChannelCreate,
      xrplNetwork: XRPLNetwork.test
    )

    // THEN the result is nil.
    XCTAssertNil(xrpPaymentChannelCreate)
  }

  // MARK: - Org_Xrpl_Rpc_V1_PaymentChannelFund

  func testConvertPaymentChannelFundAllFields() {
    // GIVEN a PaymentChannelFund protocol buffer with all fields set.
    let paymentChannelFund = Org_Xrpl_Rpc_V1_PaymentChannelFund.testPaymentChannelFundAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelFund = XRPPaymentChannelFund(paymentChannelFund: paymentChannelFund)

    // THEN the PaymentChannelFund converted as expected.
    XCTAssertEqual(
      xrpPaymentChannelFund?.channel,
      String(decoding: paymentChannelFund.channel.value, as: UTF8.self)
    )
    XCTAssertEqual(
      xrpPaymentChannelFund?.amount,
      XRPCurrencyAmount(currencyAmount: paymentChannelFund.amount.value)
    )
    XCTAssertEqual(
      xrpPaymentChannelFund?.expiration,
      paymentChannelFund.expiration.value
    )
  }

  func testConvertPaymentChannelFundMandatoryFields() {
    // GIVEN a PaymentChannelFund protocol buffer with mandatory fields set.
    let paymentChannelFund = Org_Xrpl_Rpc_V1_PaymentChannelFund.testPaymentChannelFundMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelFund = XRPPaymentChannelFund(paymentChannelFund: paymentChannelFund)

    // THEN the PaymentChannelFund converted as expected.
    XCTAssertEqual(
      xrpPaymentChannelFund?.channel,
      String(decoding: paymentChannelFund.channel.value, as: UTF8.self)
    )
    XCTAssertEqual(
      xrpPaymentChannelFund?.amount,
      XRPCurrencyAmount(currencyAmount: paymentChannelFund.amount.value)
    )
    XCTAssertNil(xrpPaymentChannelFund?.expiration)
  }

  func testConvertPaymentChannelFundMissingFields() {
    // GIVEN a PaymentChannelFund protocol buffer missing the amount field.
    let paymentChannelFund = Org_Xrpl_Rpc_V1_PaymentChannelFund.testPaymentChannelFundMissingAmount

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpPaymentChannelFund = XRPPaymentChannelFund(paymentChannelFund: paymentChannelFund)

    // THEN the result is nil.
    XCTAssertNil(xrpPaymentChannelFund)
  }

  // MARK: - Org_Xrpl_Rpc_V1_SetRegularKey

  func testConvertSetRegularKeyWithKeySet() {
    // GIVEN a SetRegularKey protocol buffer with regularKey set.
    let setRegularKey = Org_Xrpl_Rpc_V1_SetRegularKey.testSetRegularKeyWithKeySet

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpSetRegularKey = XRPSetRegularKey(setRegularKey: setRegularKey)

    // THEN the SetRegularKey converted as expected.
    XCTAssertEqual(xrpSetRegularKey?.regularKey, setRegularKey.regularKey.value.address)
  }

  func testConvertSetRegularKeyWithNoKey() {
    // GIVEN a SetRegularKey protocol buffer without regularKey set.
    let setRegularKey = Org_Xrpl_Rpc_V1_SetRegularKey.testSetRegularKeyNoKey

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpSetRegularKey = XRPSetRegularKey(setRegularKey: setRegularKey)

    // THEN the SetRegularKey converted as expected.
    XCTAssertNil(xrpSetRegularKey?.regularKey)
  }

  // MARK: - Org_Xrpl_Rpc_V1_SignerListSet

  func testConvertSignerListSetAllFields() {
    // GIVEN a SetRegularKey protocol buffer with all fields set.
    let signerListSet = Org_Xrpl_Rpc_V1_SignerListSet.testSignerListSetAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpSignerListSet = XRPSignerListSet(signerListSet: signerListSet)

    // THEN the SignerListSet converted as expected.
    let expectedSignerEntries = [
      XRPSignerEntry(signerEntry: .testSignerEntry1),
      XRPSignerEntry(signerEntry: .testSignerEntry2)
    ]

    XCTAssertEqual(xrpSignerListSet?.signerQuorum, signerListSet.signerQuorum.value)
    XCTAssertEqual(xrpSignerListSet?.signerEntries, expectedSignerEntries)
  }

  func testConvertSignerListSetNoEntries() {
    // GIVEN a SignerListSet protocol buffer without signer entries.
    let signerListSet = Org_Xrpl_Rpc_V1_SignerListSet.testSignerListSetNoEntries

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpSignerListSet = XRPSignerListSet(signerListSet: signerListSet)

    // THEN the protocol buffer converted as expected.
    XCTAssertEqual(xrpSignerListSet?.signerQuorum, signerListSet.signerQuorum.value)
    XCTAssertNil(xrpSignerListSet?.signerEntries)
  }

  func testConvertSignerListSetMissingQuorum() {
    // GIVEN a SignerListSet protocol buffer without signerQuorum set.
    let signerListSet = Org_Xrpl_Rpc_V1_SignerListSet.testSignerListSetMissingQuorum

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpSignerListSet = XRPSignerListSet(signerListSet: signerListSet)

    // THEN the result is nil.
    XCTAssertNil(xrpSignerListSet)
  }

  // MARK: - Org_Xrpl_Rpc_V1_TrustSet

  func testConvertTrustSetAllFields() {
    // GIVEN a TrustSet protocol buffer with all fields set.
    let trustSet = Org_Xrpl_Rpc_V1_TrustSet.testTrustSetAllFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpTrustSet = XRPTrustSet(trustSet: trustSet)

    // THEN the TrustSet converted as expected.
    XCTAssertEqual(
      xrpTrustSet?.limitAmount,
      XRPCurrencyAmount(currencyAmount: trustSet.limitAmount.value)
    )
    XCTAssertEqual(xrpTrustSet?.qualityIn, trustSet.qualityIn.value)
    XCTAssertEqual(xrpTrustSet?.qualityOut, trustSet.qualityOut.value)
  }

  func testConvertTrustSetMandatoryFields() {
    // GIVEN a TrustSet protocol buffer with only mandatory fields set.
    let trustSet = Org_Xrpl_Rpc_V1_TrustSet.testTrustSetMandatoryFields

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpTrustSet = XRPTrustSet(trustSet: trustSet)

    // THEN the TrustSet converted as expected.
    XCTAssertEqual(
      xrpTrustSet?.limitAmount,
      XRPCurrencyAmount(currencyAmount: trustSet.limitAmount.value)
    )
    XCTAssertNil(xrpTrustSet?.qualityIn)
    XCTAssertNil(xrpTrustSet?.qualityOut)
  }

  func testConvertTrustSetMissingFields() {
    // GIVEN a TrustSet protocol buffer missing the limitAmount field.
    let trustSet = Org_Xrpl_Rpc_V1_TrustSet.testTrustSetMissingLimitAmount

    // WHEN the protocol buffer is converted to a native Swift type.
    let xrpTrustSet = XRPTrustSet(trustSet: trustSet)

    // THEN the result is nil.
    XCTAssertNil(xrpTrustSet)
  }
}
