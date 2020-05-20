import XpringKit

extension Org_Xrpl_Rpc_V1_GetTransactionResponse {
  public static let testGetTransactionResponse = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
    $0.transaction = .testTransaction
    $0.hash = .testHash
    $0.date = Org_Xrpl_Rpc_V1_Date.with {
      $0.value = .testTimestamp
    }
    $0.meta = Org_Xrpl_Rpc_V1_Meta.with {
      $0.deliveredAmount = Org_Xrpl_Rpc_V1_DeliveredAmount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
            $0.drops = .testDeliveredAmount
          }
        }
      }
    }
  }

  public static let invalidTestGetTransactionResponse = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
    $0.transaction = .invalidTestTransactionBadPayment
    $0.hash = .testHash
  }

  public static let invalidTestGetTransactionResponseUnsupportedType = Org_Xrpl_Rpc_V1_GetTransactionResponse.with {
    $0.transaction = .invalidTestTransactionUnsupportedType
    $0.hash = .testHash
  }
}
