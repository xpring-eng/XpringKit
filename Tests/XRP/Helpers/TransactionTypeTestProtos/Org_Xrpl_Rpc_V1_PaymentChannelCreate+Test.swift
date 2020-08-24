import XpringKit

extension Org_Xrpl_Rpc_V1_PaymentChannelCreate {
  public static let testPaymentChannelCreateAllFields = Org_Xrpl_Rpc_V1_PaymentChannelCreate.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
      $0.value = .testDestinationTag
    }
    $0.settleDelay = Org_Xrpl_Rpc_V1_SettleDelay.with {
      $0.value = .testSettleDelay
    }
    $0.publicKey = Org_Xrpl_Rpc_V1_PublicKey.with {
      $0.value = .testPublicKey
    }
    $0.cancelAfter = Org_Xrpl_Rpc_V1_CancelAfter.with {
      $0.value = .testCancelAfterValue
    }
  }

  public static let testPaymentChannelCreateMandatoryFields = Org_Xrpl_Rpc_V1_PaymentChannelCreate.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.settleDelay = Org_Xrpl_Rpc_V1_SettleDelay.with {
      $0.value = .testSettleDelay
    }
    $0.publicKey = Org_Xrpl_Rpc_V1_PublicKey.with {
      $0.value = .testPublicKey
    }
  }

  public static let testPaymentChannelCreateMissingDest = Org_Xrpl_Rpc_V1_PaymentChannelCreate.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.settleDelay = Org_Xrpl_Rpc_V1_SettleDelay.with {
      $0.value = .testSettleDelay
    }
    $0.publicKey = Org_Xrpl_Rpc_V1_PublicKey.with {
      $0.value = .testPublicKey
    }
  }
}
