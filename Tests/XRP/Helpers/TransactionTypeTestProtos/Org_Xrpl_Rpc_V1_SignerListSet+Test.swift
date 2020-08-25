import XpringKit

extension Org_Xrpl_Rpc_V1_SignerListSet {
  public static let testSignerListSetAllFields = Org_Xrpl_Rpc_V1_SignerListSet.with {
    $0.signerQuorum = Org_Xrpl_Rpc_V1_SignerQuorum.with {
      $0.value = .testSignerQuorum
    }
    $0.signerEntries = [.testSignerEntry1, .testSignerEntry2]
  }

  public static let testSignerListSetNoEntries = Org_Xrpl_Rpc_V1_SignerListSet.with {
    $0.signerQuorum = Org_Xrpl_Rpc_V1_SignerQuorum.with {
      $0.value = .testSignerQuorum
    }
  }

  public static let testSignerListSetMissingQuorum = Org_Xrpl_Rpc_V1_SignerListSet()
}
