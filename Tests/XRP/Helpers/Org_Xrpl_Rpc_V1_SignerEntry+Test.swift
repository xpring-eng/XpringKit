import XpringKit

extension Org_Xrpl_Rpc_V1_SignerEntry {
  public static let testSignerEntry1 = Org_Xrpl_Rpc_V1_SignerEntry.with {
    $0.account = Org_Xrpl_Rpc_V1_Account.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.signerWeight = Org_Xrpl_Rpc_V1_SignerWeight.with {
      $0.value = .testSignerWeight1
    }
  }

  public static let testSignerEntry2 = Org_Xrpl_Rpc_V1_SignerEntry.with {
    $0.account = Org_Xrpl_Rpc_V1_Account.with {
      $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = .testClassicAddress
      }
    }
    $0.signerWeight = Org_Xrpl_Rpc_V1_SignerWeight.with {
      $0.value = .testSignerWeight2
    }
  }
}
