import SwiftGRPC
import XpringKit

public class FakeIlpBalanceNetworkClient {

    private let getBalanceResult: Result<Org_Interledger_Stream_Proto_GetBalanceResponse, Error>

    public init(getBalanceResult: Result<Org_Interledger_Stream_Proto_GetBalanceResponse, Error>) {
        self.getBalanceResult = getBalanceResult
    }
}

extension FakeIlpBalanceNetworkClient: IlpNetworkBalanceClient {
    public func getBalance(_ request: Org_Interledger_Stream_Proto_GetBalanceRequest,
                           metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        switch getBalanceResult {
        case .success(let balance):
            return balance
        case .failure(let error):
            throw error
        }
    }
}
