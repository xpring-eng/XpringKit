import XpringKit

/// A fake network client which faekse calls.
public class FakeNetworkClient {
    /// Result of a call to getAccountInfo
    private let accountInfoResult: Result<AccountInfo, Error>

    /// Initialize a new fake NetworkClient.
    ///
    /// - Parameter accountInfoResult: A result which will be used to determine the behavior of getAccountInfo()
    public init(accountInfoResult: Result<AccountInfo, Error>) {
        self.accountInfoResult = accountInfoResult
    }
}

/// Conform to NetworkClient protocol, returning faked results.
extension FakeNetworkClient: NetworkClient {
    public func getAccountInfo(_ request: AccountInfoRequest) throws -> AccountInfo {
        switch accountInfoResult {
        case .success(let accountInfo):
            return accountInfo
        case .failure(let error):
            throw error
        }
    }
}
