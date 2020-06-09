import BigInt
import XCTest
@testable import XpringKit

// TODO(keefertaylor): Refactor these to separate files.
extension Org_Xrpl_Rpc_V1_Currency {
  static let testCurrency = Org_Xrpl_Rpc_V1_Currency.with {
    $0.code = Data([1, 2, 3])
    $0.name = "currencyName"
  }
}

extension Org_Xrpl_Rpc_V1_Payment.PathElement {
  static let testPathElement = Org_Xrpl_Rpc_V1_Payment.PathElement.with {
    $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r123"
    }
    $0.currency = .testCurrency
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r456"
    }
  }
}

extension Org_Xrpl_Rpc_V1_IssuedCurrencyAmount {
  static let testIssuedCurrency = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {
    $0.currency = .testCurrency
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r123"
    }
    $0.value = "15"
  }

  // Invalid currency, value is non - numeric
  static let testInvalidIssuedCurrency = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {
    $0.currency = .testCurrency
    $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = "r123"
    }
    $0.value = "xrp" // Invalid because non - numeric
  }
}

/// Tests conversion of protocol buffer to native Swift structs.
final class ProtocolBufferConversionTests: XCTestCase {

  // MARK: - Org_Xrpl_Rpc_V1_Currency

  func testConvertCurrency() {
    // GIVEN a Currency protocol buffer with a code and a name.
    let currencyProto = Org_Xrpl_Rpc_V1_Currency.testCurrency

    // WHEN the protocol buffer is converted to a native Swift type.
    let currency = XRPCurrency(currency: currencyProto)

    // THEN the currency converted as expected.
    XCTAssertEqual(currency.code, currencyProto.code)
    XCTAssertEqual(currency.name, currencyProto.name)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Transaction.PathElement

  func testConvertPathElementAllFieldsSet() {
    // GIVEN a PathElement protocol buffer with all fields set.
    let pathElementProto = Org_Xrpl_Rpc_V1_Payment.PathElement.testPathElement

    // WHEN the protocol buffer is converted to a native Swift type.
    let pathElement = XRPPathElement(pathElement: pathElementProto)

    // THEN the currency converted as expected.
    XCTAssertEqual(pathElement.account, pathElementProto.account.address)
    XCTAssertEqual(pathElement.currency, XRPCurrency(currency: .testCurrency))
    XCTAssertEqual(pathElement.issuer, pathElementProto.issuer.address)
  }

  func testConvertPathElementNoFieldsSet() {
    // GIVEN a PathElement protocol buffer with no fields set.
    let pathElementProto = Org_Xrpl_Rpc_V1_Payment.PathElement()

    // WHEN the protocol buffer is converted to a native Swift type.
    let pathElement = XRPPathElement(pathElement: pathElementProto)

    // THEN the currency converted as expected.
    XCTAssertNil(pathElement.account)
    XCTAssertNil(pathElement.currency)
    XCTAssertNil(pathElement.issuer)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Transaction.Path

  func testConvertPathsWithNoPaths() {
    // GIVEN a set of paths with zero paths.
    let pathProto = Org_Xrpl_Rpc_V1_Payment.Path()

    // WHEN the protocol buffer is converted to a native Swift type.
    let path = XRPPath(path: pathProto)

    // THEN there are zero paths in the output.
    XCTAssertEqual(path.pathElements.count, 0)
  }

  func testConvertPathsWithOnePath() {
    // GIVEN a set of paths with one path.
    let pathProto = Org_Xrpl_Rpc_V1_Payment.Path.with {
      $0.elements = [ .testPathElement ]
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let path = XRPPath(path: pathProto)

    // THEN there is one path in the output.
    XCTAssertEqual(path.pathElements.count, 1)
  }

  func testConvertPathsWithManyPaths() {
    // GIVEN a set of paths with one path.
    let pathProto = Org_Xrpl_Rpc_V1_Payment.Path.with {
      $0.elements = [ .testPathElement, .testPathElement, .testPathElement ]
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let path = XRPPath(path: pathProto)

    // THEN there are multiple paths in the output.
    XCTAssertEqual(path.pathElements.count, 3)
  }

  // MARK: - Org_Xrpl_Rpc_V1_IssuedCurrencyAmount

  func testConvertIssuedCurrency() {
    // GIVEN an issued currency protocol buffer
    let issuedCurrencyProto = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.with {
      $0.currency = .testCurrency
      $0.issuer = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = "r123"
      }
      $0.value = "12345"
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let issuedCurrency = XRPIssuedCurrency(issuedCurrency: issuedCurrencyProto)

    // THEN the issued currency converted as expected.
    XCTAssertEqual(issuedCurrency?.currency, XRPCurrency(currency: issuedCurrencyProto.currency))
    XCTAssertEqual(issuedCurrency?.issuer, issuedCurrencyProto.issuer.address)
    XCTAssertEqual(issuedCurrency?.value, BigInt(issuedCurrencyProto.value))
  }

  func testConvertIssuedCurrencyWithBadValue() {
    // GIVEN an issued currency protocol buffer with a non numeric value
    let issuedCurrencyProto = Org_Xrpl_Rpc_V1_IssuedCurrencyAmount.testInvalidIssuedCurrency

    // WHEN the protocol buffer is converted to a native Swift type.
    let issuedCurrency = XRPIssuedCurrency(issuedCurrency: issuedCurrencyProto)

    // THEN the result is nil
    XCTAssertNil(issuedCurrency)
  }

  // MARK: - Org_Xrpl_Rpc_V1_CurrencyAmount

  func testConvertCurrencyAmountWithDrops() {
    // GIVEN an currency amount protocol buffer with an XRP amount.
    let drops: UInt64 = 10
    let currencyAmountProto = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
      $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
        $0.drops = drops
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmountProto)

    // THEN the result has drops set and no issued amount.
    XCTAssertNil(currencyAmount?.issuedCurrency)
    XCTAssertEqual(currencyAmount?.drops, drops)
  }

  func testConvertCurrencyAmountWithIssuedCurrency() {
    // GIVEN an currency amount protocol buffer with an issued currency amount.
    let currencyAmountProto = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
      $0.issuedCurrencyAmount = .testIssuedCurrency
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmountProto)

    // THEN the result has an issued currency set and no amount.
    XCTAssertEqual(currencyAmount?.issuedCurrency, XRPIssuedCurrency(issuedCurrency: .testIssuedCurrency))
    XCTAssertNil(currencyAmount?.drops)
  }

  func testConvertCurrencyAmountWithBadInputs() {
    // GIVEN an currency amount protocol buffer with no amounts
    let currencyAmountProto = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
      $0.issuedCurrencyAmount = .testInvalidIssuedCurrency
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let currencyAmount = XRPCurrencyAmount(currencyAmount: currencyAmountProto)

    // THEN the result is nil
    XCTAssertNil(currencyAmount)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Signer

  func testConvertSignerAllFieldsSet() {
    // GIVEN a Signer protocol buffer with all fields set.
    let account = "r123"
    let signingPublicKey = Data([1, 2, 3])
    let transactionSignature = Data([4, 5, 6])
    let signerProto = Org_Xrpl_Rpc_V1_Signer.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let signer = XRPSigner(signer: signerProto)

    // THEN all fields are present and converted correct.
    XCTAssertEqual(signer.account, account)
    XCTAssertEqual(signer.signingPublicKey, signingPublicKey)
    XCTAssertEqual(signer.transactionSignature, transactionSignature)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Payment

  func testConvertPaymentWithAllFieldsSet() {
    // GIVEN a pyament protocol buffer with all fields set.
    let paymentProto = Org_Xrpl_Rpc_V1_Payment.with {
      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testIssuedCurrency
        }
      }
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = "r123"
        }
      }
      $0.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
        $0.value = 2
      }
      $0.deliverMin = Org_Xrpl_Rpc_V1_DeliverMin.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
            $0.drops = 10
          }
        }
      }
      $0.invoiceID = Org_Xrpl_Rpc_V1_InvoiceID.with {
        $0.value = Data([1, 2, 3])
      }
      $0.paths = [
        Org_Xrpl_Rpc_V1_Payment.Path.with {
          $0.elements = [
            Org_Xrpl_Rpc_V1_Payment.PathElement.with {
              $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
                $0.address = "r456"
              }
            }
          ]
        },
        Org_Xrpl_Rpc_V1_Payment.Path.with {
          $0.elements = [
            Org_Xrpl_Rpc_V1_Payment.PathElement.with {
              $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
                $0.address = "r789"
              }
            },
            Org_Xrpl_Rpc_V1_Payment.PathElement.with {
              $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
                $0.address = "rabc"
              }
            }
          ]
        }
      ]
      $0.sendMax = Org_Xrpl_Rpc_V1_SendMax.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
            $0.drops = 20
          }
        }
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let payment = XRPPayment(payment: paymentProto, xrplNetwork: XRPLNetwork.test)
    let expectedXAddress = Utils.encode(
      classicAddress: payment!.destination,
      tag: payment?.destinationTag,
      isTest: true
    )
    // THEN the result is as expected.
    XCTAssertEqual(payment?.amount, XRPCurrencyAmount(currencyAmount: paymentProto.amount.value))
    XCTAssertEqual(payment?.destination, paymentProto.destination.value.address)
    XCTAssertEqual(payment?.destinationTag, paymentProto.destinationTag.value)
    XCTAssertEqual(payment?.destinationXAddress, expectedXAddress)
    XCTAssertEqual(payment?.deliverMin, XRPCurrencyAmount(currencyAmount: paymentProto.deliverMin.value))
    XCTAssertEqual(payment?.invoiceID, paymentProto.invoiceID.value)
    XCTAssertEqual(payment?.paths, paymentProto.paths.map { XRPPath(path: $0) })
    XCTAssertEqual(payment?.sendMax, XRPCurrencyAmount(currencyAmount: paymentProto.sendMax.value))
  }

  func testConvertPaymentWithOnlyMandatoryFieldsSet() {
    // GIVEN a payment protocol buffer with only mandatory fields set.
    let paymentProto = Org_Xrpl_Rpc_V1_Payment.with {
      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testIssuedCurrency
        }
      }
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = "r123"
        }
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let payment = XRPPayment(payment: paymentProto, xrplNetwork: XRPLNetwork.test)
    let expectedXAddress = Utils.encode(
      classicAddress: payment!.destination,
      tag: payment?.destinationTag,
      isTest: true
    )

    // THEN the result is as expected.
    XCTAssertEqual(payment?.amount, XRPCurrencyAmount(currencyAmount: paymentProto.amount.value))
    XCTAssertEqual(payment?.destination, paymentProto.destination.value.address)
    XCTAssertNil(payment?.destinationTag)
    XCTAssertEqual(payment?.destinationXAddress, expectedXAddress)
    XCTAssertNil(payment?.deliverMin)
    XCTAssertNil(payment?.invoiceID)
    XCTAssertNil(payment?.paths)
    XCTAssertNil(payment?.sendMax)
  }

  func testConvertPaymentWithInvalidAmountField() {
    // GIVEN a pyament protocol buffer with an invalid amount field
    let paymentProto = Org_Xrpl_Rpc_V1_Payment.with {
      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testInvalidIssuedCurrency
        }
      }
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = "r123"
        }
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type THEN the result is nil
    XCTAssertNil(XRPPayment(payment: paymentProto, xrplNetwork: XRPLNetwork.test))
  }

  func testConvertPaymentWithInvalidDeliverMinField() {
    // GIVEN a payment protocol buffer with an invalid deliverMin field
    let paymentProto = Org_Xrpl_Rpc_V1_Payment.with {
      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testIssuedCurrency
        }
      }
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = "r123"
        }
      }
      $0.deliverMin = Org_Xrpl_Rpc_V1_DeliverMin.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testInvalidIssuedCurrency
        }
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type THEN the result is nil
    XCTAssertNil(XRPPayment(payment: paymentProto, xrplNetwork: XRPLNetwork.test))
  }

  func testConvertPaymentWithInvalidSendMaxField() {
    // GIVEN a payment protocol buffer with an invalid sendMax field
    let paymentProto = Org_Xrpl_Rpc_V1_Payment.with {
      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testIssuedCurrency
        }
      }
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = "r123"
        }
      }
      $0.sendMax = Org_Xrpl_Rpc_V1_SendMax.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testInvalidIssuedCurrency
        }
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type THEN the result is nil
    XCTAssertNil(XRPPayment(payment: paymentProto, xrplNetwork: XRPLNetwork.test))
  }

  // MARK: - Org_Xrpl_Rpc_V1_Memo

  func testConvertMemoWithAllFieldsSet() {
    // GIVEN a memo with all fields set.
    let memoData = Data([1, 2, 3])
    let memoFormat = Data([4, 5, 6])
    let memoType = Data([7, 8, 9])
    let memoProto = Org_Xrpl_Rpc_V1_Memo.with {
      $0.memoData = Org_Xrpl_Rpc_V1_MemoData.with {
        $0.value = memoData
      }
      $0.memoFormat = Org_Xrpl_Rpc_V1_MemoFormat.with {
        $0.value = memoFormat
      }
      $0.memoType = Org_Xrpl_Rpc_V1_MemoType.with {
        $0.value = memoType
      }
    }

    // WHEN the protocol buffer is converted to a native Swift type
    let memo = XRPMemo(memo: memoProto)

    // THEN all fields are present and set correctly.
    XCTAssertEqual(memo.data, memoData)
    XCTAssertEqual(memo.format, memoFormat)
    XCTAssertEqual(memo.type, memoType)
  }

  func testConvertMemoWithNoFieldsSet() {
    // GIVEN a memo with no fields set.
    let memoProto = Org_Xrpl_Rpc_V1_Memo()

    // WHEN the protocol buffer is converted to a native Swift type
    let memo = XRPMemo(memo: memoProto)

    // THEN all fields are empty.
    XCTAssertNil(memo.data)
    XCTAssertNil(memo.format)
    XCTAssertNil(memo.type)
  }

  // MARK: - Org_Xrpl_Rpc_V1_Transaction

  func testConvertPaymentTransactionAllCommonFieldsSet() {
    // GIVEN a Transaction protocol buffer with all common fields set.
    let hash = Data([2, 4, 6])
    let timestamp: UInt32 = 0
    let deliveredAmount: UInt64 = 20
    let account = "r123"
    let fee: UInt64 = 1
    let sequence: UInt32 = 2
    let signingPublicKey = Data([1, 2, 3])
    let transactionSignature = Data([4, 5, 6])
    let accountTransactionID = Data([7, 8, 9])
    let flags = RippledFlags(rawValue: 4)
    let lastLedgerSequence: UInt32 = 5
    let memoData = Data([1, 2, 3])
    let memoFormat = Data([4, 5, 6])
    let memoType = Data([7, 8, 9])
    let validated = true
    let ledgerIndex = UInt32(1_000)

    let memoProto = Org_Xrpl_Rpc_V1_Memo.with {
      $0.memoData = Org_Xrpl_Rpc_V1_MemoData.with {
        $0.value = memoData
      }
      $0.memoFormat = Org_Xrpl_Rpc_V1_MemoFormat.with {
        $0.value = memoFormat
      }
      $0.memoType = Org_Xrpl_Rpc_V1_MemoType.with {
        $0.value = memoType
      }
    }
    let signerProto = Org_Xrpl_Rpc_V1_Signer.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }
    }
    let sourceTag: UInt32 = 6

    let transactionProto = Org_Xrpl_Rpc_V1_Transaction.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.fee = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
        $0.drops = fee
      }
      $0.sequence = Org_Xrpl_Rpc_V1_Sequence.with {
        $0.value = sequence
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }
      $0.accountTransactionID = Org_Xrpl_Rpc_V1_AccountTransactionID.with {
        $0.value = accountTransactionID
      }
      $0.flags = Org_Xrpl_Rpc_V1_Flags.with {
        $0.value = flags.rawValue
      }
      $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
        $0.value = lastLedgerSequence
      }
      $0.memos = [memoProto]
      $0.signers = [signerProto]
      $0.sourceTag = Org_Xrpl_Rpc_V1_SourceTag.with {
        $0.value = sourceTag
      }

      $0.payment = Org_Xrpl_Rpc_V1_Payment.with {
        $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
          $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
            $0.issuedCurrencyAmount = .testIssuedCurrency
          }
        }
        $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
          $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
            $0.address = "r123"
          }
        }
      }
    }

    let getTransactionResponseProto = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = transactionProto
      $0.hash = hash
      $0.date = Org_Xrpl_Rpc_V1_Date.with {
        $0.value = timestamp
      }
      $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
        $0.deliveredAmount = Org_Xrpl_Rpc_V1_DeliveredAmount.with {
          $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
            $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
              $0.drops = deliveredAmount
            }
          }
        }
      }
      $0.validated = validated
      $0.ledgerIndex = ledgerIndex
    }
    // WHEN the protocol buffer is converted to a native Swift type.
    let transaction = XRPTransaction(getTransactionResponse: getTransactionResponseProto, xrplNetwork: XRPLNetwork.test)
    let expectedXAddress = Utils.encode(
      classicAddress: transaction!.account,
      tag: transaction!.sourceTag,
      isTest: true
    )

    // THEN all fields are present and converted correctly.
    XCTAssertEqual(transaction?.hash, [UInt8](hash).toHex())
    XCTAssertEqual(transaction?.account, account)
    XCTAssertEqual(transaction?.fee, fee)
    XCTAssertEqual(transaction?.sequence, sequence)
    XCTAssertEqual(transaction?.signingPublicKey, signingPublicKey)
    XCTAssertEqual(transaction?.transactionSignature, transactionSignature)
    XCTAssertEqual(transaction?.accountTransactionID, accountTransactionID)
    XCTAssertEqual(transaction?.flags, flags)
    XCTAssertEqual(transaction?.lastLedgerSequence, lastLedgerSequence)
    XCTAssertEqual(transaction?.memos, [ XRPMemo(memo: memoProto) ])
    XCTAssertEqual(transaction?.signers, [ XRPSigner(signer: signerProto) ])
    XCTAssertEqual(transaction?.sourceTag, sourceTag)
    XCTAssertEqual(transaction?.sourceXAddress, expectedXAddress)
    XCTAssertEqual(transaction?.timestamp, .expectedTimestamp)
    XCTAssertEqual(transaction?.deliveredAmount, String(deliveredAmount))
    XCTAssertEqual(transaction?.validated, validated)
    XCTAssertEqual(transaction?.ledgerIndex, ledgerIndex)
  }

  func testConvertPaymentTransactionOnlyMandatoryCommonFieldsSet() {
    // GIVEN a Transaction protocol buffer with only mandatory common fields set.
    let hash = Data([2, 4, 6])
    let account = "r123"
    let fee: UInt64 = 1
    let sequence: UInt32 = 2
    let signingPublicKey = Data([1, 2, 3])
    let transactionSignature = Data([4, 5, 6])

    let transactionProto = Org_Xrpl_Rpc_V1_Transaction.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.fee = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
        $0.drops = fee
      }
      $0.sequence = Org_Xrpl_Rpc_V1_Sequence.with {
        $0.value = sequence
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }

      $0.payment = Org_Xrpl_Rpc_V1_Payment.with {
        $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
          $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
            $0.issuedCurrencyAmount = .testIssuedCurrency
          }
        }
        $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
          $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
            $0.address = "r123"
          }
        }
      }
    }

    let getTransactionResponseProto = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = transactionProto
      $0.hash = hash
    }
    // WHEN the protocol buffer is converted to a native Swift type.
    let transaction = XRPTransaction(
      getTransactionResponse: getTransactionResponseProto,
      xrplNetwork: XRPLNetwork.test
    )

    let expectedXAddress = Utils.encode(
      classicAddress: transaction!.account,
      tag: transaction!.sourceTag,
      isTest: true
    )

    // THEN all fields are present and converted correctly.
    XCTAssertEqual(transaction?.hash, [UInt8](hash).toHex())
    XCTAssertEqual(transaction?.account, account)
    XCTAssertEqual(transaction?.fee, fee)
    XCTAssertEqual(transaction?.sequence, sequence)
    XCTAssertEqual(transaction?.signingPublicKey, signingPublicKey)
    XCTAssertEqual(transaction?.transactionSignature, transactionSignature)
    XCTAssertNil(transaction?.accountTransactionID)
    XCTAssertNil(transaction?.flags)
    XCTAssertNil(transaction?.lastLedgerSequence)
    XCTAssertNil(transaction?.memos)
    XCTAssertNil(transaction?.signers)
    XCTAssertNil(transaction?.sourceTag)
    XCTAssertEqual(transaction?.sourceXAddress, expectedXAddress)
    XCTAssertNil(transaction?.timestamp)
    XCTAssertNil(transaction?.deliveredAmount)
  }

  func testConvertPaymentTransactionWithBadPaymentFields() {
    // GIVEN a Transaction protocol buffer with payment fields which are incorrect
    let hash = Data([2, 4, 6])
    let account = "r123"
    let fee: UInt64 = 1
    let sequence: UInt32 = 2
    let signingPublicKey = Data([1, 2, 3])
    let transactionSignature = Data([4, 5, 6])

    let transactionProto = Org_Xrpl_Rpc_V1_Transaction.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.fee = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
        $0.drops = fee
      }
      $0.sequence = Org_Xrpl_Rpc_V1_Sequence.with {
        $0.value = sequence
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }

      $0.payment = Org_Xrpl_Rpc_V1_Payment() // Empty fields, will not convert
    }

    let getTransactionResponseProto = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = transactionProto
      $0.hash = hash
    }
    // WHEN the protocol buffer is converted to a native Swift type.
    let transaction = XRPTransaction(getTransactionResponse: getTransactionResponseProto, xrplNetwork: XRPLNetwork.test)

    // THEN the result is nil
    XCTAssertNil(transaction)
  }

  func testConvertUnsupportedTransactionType() {
    // GIVEN a Transaction protocol buffer with an unsupported transaction type.
    let hash = Data([2, 4, 6])
    let account = "r123"
    let fee: UInt64 = 1
    let sequence: UInt32 = 2
    let signingPublicKey = Data([1, 2, 3])
    let transactionSignature = Data([4, 5, 6])

    let transactionProto = Org_Xrpl_Rpc_V1_Transaction.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = account
        }
      }
      $0.fee = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
        $0.drops = fee
      }
      $0.sequence = Org_Xrpl_Rpc_V1_Sequence.with {
        $0.value = sequence
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = signingPublicKey
      }
      $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
        $0.value = transactionSignature
      }

      $0.checkCash = Org_Xrpl_Rpc_V1_CheckCash() // Unsupported
    }

    let getTransactionResponseProto = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
      $0.transaction = transactionProto
      $0.hash = hash
    }

    // WHEN the protocol buffer is converted to a native Swift type.
    let transaction = XRPTransaction(getTransactionResponse: getTransactionResponseProto, xrplNetwork: XRPLNetwork.test)

    // THEN the result is nil
    XCTAssertNil(transaction)
  }
}
