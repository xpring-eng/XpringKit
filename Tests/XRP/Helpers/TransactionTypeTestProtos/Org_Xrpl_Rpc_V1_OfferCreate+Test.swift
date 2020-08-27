import XpringKit

extension Org_Xrpl_Rpc_V1_OfferCreate {
  public static let testOfferCreateAllFields = Org_Xrpl_Rpc_V1_OfferCreate.with {
    $0.takerGets = Org_Xrpl_Rpc_V1_TakerGets.with {
      $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.testCurrencyAmountIssuedCurrency
    }
    $0.takerPays = Org_Xrpl_Rpc_V1_TakerPays.with {
      $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.testCurrencyAmountIssuedCurrency
    }
    $0.expiration = Org_Xrpl_Rpc_V1_Expiration.with {
      $0.value = .testExpirationValue
    }
    $0.offerSequence = Org_Xrpl_Rpc_V1_OfferSequence.with {
      $0.value = .testOfferSequenceValue
    }
  }

  public static let testOfferCreateMandatoryFields = Org_Xrpl_Rpc_V1_OfferCreate.with {
    $0.takerGets = Org_Xrpl_Rpc_V1_TakerGets.with {
      $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.testCurrencyAmountIssuedCurrency
    }
    $0.takerPays = Org_Xrpl_Rpc_V1_TakerPays.with {
      $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.testCurrencyAmountIssuedCurrency
    }
  }

  public static let testOfferCreateMissingTakerGets = Org_Xrpl_Rpc_V1_OfferCreate.with {
    $0.takerPays = Org_Xrpl_Rpc_V1_TakerPays.with {
      $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.testCurrencyAmountIssuedCurrency
    }
  }
}
