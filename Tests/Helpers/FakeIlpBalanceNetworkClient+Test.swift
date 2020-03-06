import XpringKit

extension FakeIlpBalanceNetworkClient {

    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpBalanceNetworkClient(
        getBalanceResult: .success(.testGetBalanceResponse)
    )

}
