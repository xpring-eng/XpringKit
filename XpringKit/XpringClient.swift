public protocol NetworkClient {
    func getAccountInfo(_ request: AccountInfoRequest) throws -> AccountInfo
}

extension RippledServiceClient: NetworkClient {
}

public typealias Address = String

/// An interface into the Xpring Platform.
public class XpringClient {
    /// A network client that will make and receive requests.
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func getBalance(for address: Address) throws -> XRPAmount {
        let accountInfoRequest = AccountInfoRequest.with {
            $0.address = address
        }

        let accountInfo = try networkClient.getAccountInfo(accountInfoRequest)
        let accountData = accountInfo.accountData
        let drops = accountData.balance

        return XRPAmount.with {
            $0.drops = drops
        }
    }
}
