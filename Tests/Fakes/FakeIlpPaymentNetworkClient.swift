import SwiftGRPC
import XpringKit

public class FakeIlpPaymentNetworkClient {

    private let sendPaymentResult: Result<Org_Interledger_Stream_Proto_SendPaymentResponse, Error>

    public init(sendPaymentResult: Result<Org_Interledger_Stream_Proto_SendPaymentResponse, Error>) {
        self.sendPaymentResult = sendPaymentResult
    }
}

extension FakeIlpPaymentNetworkClient: IlpNetworkPaymentClient {
    public func sendMoney(_ request: Org_Interledger_Stream_Proto_SendPaymentRequest, metadata customMetadata: Metadata) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse {
        switch sendPaymentResult {
        case .success(let payment):
            return payment
        case .failure(let error):
            throw error
        }
    }
}
