import XpringKit

public class FakeNetworkClient: NetworkClient {
    private let accountInfoResult: Result<AccountInfo, Error>

    public init(accountInfoResult: Result<AccountInfo, Error>) {
        self.accountInfoResult = accountInfoResult
    }

    public func getAccountInfo(_ request: AccountInfoRequest) throws -> AccountInfo {
        switch accountInfoResult {
        case .success(let accountInfo):
            return accountInfo
        case .failure(let error):
            throw error
        }
    }
}
