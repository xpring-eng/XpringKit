import XpringKit

extension FakeIlpPaymentNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpPaymentNetworkClient(
        sendPaymentResult: .success(.testSendPaymentResponse)
    )
}
