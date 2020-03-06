import XpringKit

extension Org_Interledger_Stream_Proto_SendPaymentResponse {
    static let testSendPaymentResponse = Org_Interledger_Stream_Proto_SendPaymentResponse.with {
        $0.originalAmount = 100
        $0.amountSent = 100
        $0.amountDelivered = 100
        $0.successfulPayment = true
    }
}
