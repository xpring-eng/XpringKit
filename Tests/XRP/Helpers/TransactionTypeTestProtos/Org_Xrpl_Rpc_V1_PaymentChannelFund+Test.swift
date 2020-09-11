import XpringKit

extension Org_Xrpl_Rpc_V1_PaymentChannelFund {
  public static let testPaymentChannelFundAllFields = Org_Xrpl_Rpc_V1_PaymentChannelFund.with {
    $0.channel = Org_Xrpl_Rpc_V1_Channel.with {
      $0.value = .testChannelValue
    }
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
    $0.expiration = Org_Xrpl_Rpc_V1_Expiration.with {
      $0.value = .testExpirationValue
    }
  }

  public static let testPaymentChannelFundMandatoryFields = Org_Xrpl_Rpc_V1_PaymentChannelFund.with {
    $0.channel = Org_Xrpl_Rpc_V1_Channel.with {
      $0.value = .testChannelValue
    }
    $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
      $0.value = .testCurrencyAmountXrpDrops
    }
  }

  public static let testPaymentChannelFundMissingAmount = Org_Xrpl_Rpc_V1_PaymentChannelFund.with {
    $0.channel = Org_Xrpl_Rpc_V1_Channel.with {
      $0.value = .testChannelValue
    }
  }
}
