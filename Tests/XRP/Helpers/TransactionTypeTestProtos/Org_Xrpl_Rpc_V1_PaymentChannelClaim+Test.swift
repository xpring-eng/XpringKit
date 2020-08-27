import XpringKit

extension Org_Xrpl_Rpc_V1_PaymentChannelClaim {
  public static let testPaymentChannelClaimAllFields = Org_Xrpl_Rpc_V1_PaymentChannelClaim.with {
    $0.channel = Org_Xrpl_Rpc_V1_Channel.with {
      $0.value = .testChannelValue
    }
    $0.balance = Org_Xrpl_Rpc_V1_Balance.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.paymentChannelSignature = Org_Xrpl_Rpc_V1_PaymentChannelSignature.with {
      $0.value = .testPaymentChannelSignature
    }
    $0.publicKey = Org_Xrpl_Rpc_V1_PublicKey.with {
      $0.value = .testPublicKey
    }
  }

  public static let testPaymentChannelClaimMandatoryFields = Org_Xrpl_Rpc_V1_PaymentChannelClaim.with {
    $0.channel = Org_Xrpl_Rpc_V1_Channel.with {
      $0.value = .testChannelValue
    }
  }

  public static let testPaymentChannelClaimMissingChannel = Org_Xrpl_Rpc_V1_PaymentChannelClaim.with {
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.paymentChannelSignature = Org_Xrpl_Rpc_V1_PaymentChannelSignature.with {
      $0.value = .testPaymentChannelSignature
    }
  }
}
