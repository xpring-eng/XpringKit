import XpringKit

extension FakeIlpPaymentNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpPaymentNetworkClient(
        sendPaymentResult: .success(.testSendPaymentResponse)
    )

    static let accountNotFoundPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.notFoundError))
    static let unauthenticatedPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.unauthenticatedError))
    static let invalidArgumentPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.invalidArgumentError))
    static let internalErrorPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.internalError))
    static let invalidAccessTokenPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(XpringIlpError.invalidAccessToken))
}
