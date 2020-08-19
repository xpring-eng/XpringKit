import XpringKit

extension Org_Xrpl_Rpc_V1_CheckCreate {
  public static let testCheckCreateAllFields = Org_Xrpl_Rpc_V1_CheckCreate.with {
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
      $0.value = .testDestinationTag
    }
    $0.sendMax = Org_Xrpl_Rpc_V1_SendMax.with {
      $0.value = .testCurrencyAmountIssuedCurrency
    }
    $0.invoiceID = Org_Xrpl_Rpc_V1_InvoiceID.with {
      $0.value = .testInvoiceIdValue
    }
    $0.expiration = Org_Xrpl_Rpc_V1_Expiration.with {
      $0.value = .testExpirationValue
    }
  }
  
  public static let testCheckCreateMandatoryFields = Org_Xrpl_Rpc_V1_CheckCreate.with {
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.sendMax = Org_Xrpl_Rpc_V1_SendMax.with {
      $0.value = .testCurrencyAmountIssuedCurrency
    }
  }
  
  public static let testCheckCreateMissingDestination = Org_Xrpl_Rpc_V1_CheckCreate.with {
    $0.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
      $0.value = .testDestinationTag
    }
    $0.sendMax = Org_Xrpl_Rpc_V1_SendMax.with {
      $0.value = .testCurrencyAmountIssuedCurrency
    }
    $0.invoiceID = Org_Xrpl_Rpc_V1_InvoiceID.with {
      $0.value = .testInvoiceIdValue
    }
    $0.expiration = Org_Xrpl_Rpc_V1_Expiration.with {
      $0.value = .testExpirationValue
    }
  }
}
