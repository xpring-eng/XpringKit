import SwiftGRPC
import XpringKit

/// A fake balance network client which fakes calls.
public class FakeIlpBalanceNetworkClient {
    /// Result of a call to getBalance
    private let getBalanceResult: Result<Org_Interledger_Stream_Proto_GetBalanceResponse, Error>

    /// Initialize a new FakeIlpBalanceNetworkClient
    ///
    /// - Parameters:
    ///     - getBalanceResult: A result which will be used to determine the behavior of getBalance()
    public init(getBalanceResult: Result<Org_Interledger_Stream_Proto_GetBalanceResponse, Error>) {
        self.getBalanceResult = getBalanceResult
    }
}

/// Conform to IlpBalanceNetworkClient protocol, returning faked results
extension FakeIlpBalanceNetworkClient: IlpNetworkBalanceClient {
    public func getBalance(
        _ request: Org_Interledger_Stream_Proto_GetBalanceRequest,
        metadata customMetadata: Metadata
    ) throws -> Org_Interledger_Stream_Proto_GetBalanceResponse {
        switch getBalanceResult {
        case .success(let balance):
            return balance
        case .failure(let error):
            throw error
        }
    }
}
