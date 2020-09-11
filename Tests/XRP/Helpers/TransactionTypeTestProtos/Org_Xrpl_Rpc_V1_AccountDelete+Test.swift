import XpringKit

extension Org_Xrpl_Rpc_V1_AccountDelete {
  public static let testAccountDeleteAllFields = Org_Xrpl_Rpc_V1_AccountDelete.with {
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testDestinationClassicAddress
      }
    }
    $0.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
      $0.value = .testDestinationTag
    }
  }

  public static let testAccountDeleteNoTag = Org_Xrpl_Rpc_V1_AccountDelete.with {
    $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testDestinationClassicAddress
      }
    }
  }

  public static let testAccountDeleteNoFields = Org_Xrpl_Rpc_V1_AccountDelete()
}
