import XpringKit

/// A fake network client which faekse calls.
public class FakeNetworkClient {
    /// Result of a call to getAccountInfo
    private let accountInfoResult: Result<Io_Xpring_AccountInfo, Error>

    /// Initialize a new fake NetworkClient.
    ///
    /// - Parameter accountInfoResult: A result which will be used to determine the behavior of getAccountInfo()
    public init(accountInfoResult: Result<Io_Xpring_AccountInfo, Error>) {
        self.accountInfoResult = accountInfoResult
    }
}

/// Conform to NetworkClient protocol, returning faked results.
extension FakeNetworkClient: NetworkClient {
    public func getAccountInfo(_ request: Io_Xpring_GetAccountInfoRequest) throws -> Io_Xpring_AccountInfo {
        switch accountInfoResult {
        case .success(let accountInfo):
            return accountInfo
        case .failure(let error):
            throw error
        }
    }
}
