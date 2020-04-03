import XpringKit

/// Extension of PaymentRequest to be used by all DefaultIlpClient tests
extension PaymentRequest {
    static let testPaymentRequest = PaymentRequest(
        .testIlpSendAmount,
        to: .testIlpPaymentPointer,
        from: .testAccountID
    )
}
