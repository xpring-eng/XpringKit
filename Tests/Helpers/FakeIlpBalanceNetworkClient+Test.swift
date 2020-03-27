import XpringKit

extension FakeIlpBalanceNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpBalanceNetworkClient(
        getBalanceResult: .success(.testGetBalanceResponse)
    )

    static let accountNotFoundBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.notFoundError))
    static let unauthenticatedBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.unauthenticatedError))
    static let invalidArgumentBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.invalidArgumentError))
    static let internalErrorBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.internalError))
    static let invalidAccessTokenBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(XpringIlpError.invalidAccessToken))
}
