import XpringKit

extension FakeIlpBalanceNetworkClient {

    static let successfulFakeNetworkClient = FakeIlpBalanceNetworkClient(
        getBalanceResult: .success(.testGetBalanceResponse)
    )

}
