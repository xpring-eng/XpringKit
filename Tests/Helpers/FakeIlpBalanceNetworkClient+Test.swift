import XpringKit

extension FakeIlpBalanceNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .success(.testGetBalanceResponse))

    /// A network client that always fails with FakeIlpError.notFoundError
    static let accountNotFoundBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.notFoundError))
    
    /// A network client that always fails with FakeIlpError.unauthenticatedError
    static let unauthenticatedBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.unauthenticatedError))
    
    /// A network client that always fails with FakeIlpError.invalidArgumentError
    static let invalidArgumentBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.invalidArgumentError))
    
    /// A network client that always fails with FakeIlpError.internalError
    static let internalErrorBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(FakeIlpError.internalError))
    
    /// A network client that always fails with XpringIlpError.invalidAccessToken
    static let invalidAccessTokenBalanceNetworkClient = FakeIlpBalanceNetworkClient(getBalanceResult: .failure(XpringIlpError.invalidAccessToken))
}
