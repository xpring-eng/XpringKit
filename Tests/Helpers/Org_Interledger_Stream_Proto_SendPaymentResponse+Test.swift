import XpringKit

extension Org_Interledger_Stream_Proto_SendPaymentResponse {
  static let testSendPaymentResponse = Org_Interledger_Stream_Proto_SendPaymentResponse.with {
    $0.originalAmount = .testIlpSendAmount
    $0.amountSent = .testIlpSendAmount
    $0.amountDelivered = .testIlpSendAmount
    $0.successfulPayment = true
  }
}
