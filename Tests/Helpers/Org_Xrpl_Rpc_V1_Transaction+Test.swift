import XpringKit

// TODO(keefertaylor): Eventually all fields in here should just reference other test objects. Reconcile in a future PR.
extension Org_Xrpl_Rpc_V1_Transaction {
  public static let testTransaction = Org_Xrpl_Rpc_V1_Transaction.with {
    $0.account = Org_Xrpl_Rpc_V1_Account.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testAddress
      }
    }
    $0.fee = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
      $0.drops = .testFee
    }
    $0.sequence = Org_Xrpl_Rpc_V1_Sequence.with {
      $0.value = .testSequence
    }
    $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
      $0.value = .testPublicKey
    }
    $0.transactionSignature = Org_Xrpl_Rpc_V1_TransactionSignature.with {
      $0.value = .testTransactionSignature
    }

    $0.payment = Org_Xrpl_Rpc_V1_Payment.with {
      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.issuedCurrencyAmount = .testIssuedCurrency
        }
      }
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = .testDestination
        }
      }
    }
  }
}
