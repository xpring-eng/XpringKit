import XpringKit

extension PaymentRequest {
    static let testPaymentRequest = PaymentRequest(
        .testIlpSendAmount,
        to: .testIlpPaymentPointer,
        from: .testAccountID
    )
}
