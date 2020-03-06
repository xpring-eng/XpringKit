import XpringKit

extension FakeIlpPaymentNetworkClient {

    static let successfulFakeNetworkClient = FakeIlpPaymentNetworkClient(
        sendPaymentResult: .success(.testSendPaymentResponse)
    )
}
