import XpringKit

extension FakeIlpPaymentNetworkClient {
    /// A network client that always succeeds
    static let successfulFakeNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .success(.testSendPaymentResponse))

    /// A network client that always fails with FakeIlpError.notFoundError
    static let accountNotFoundPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.notFoundError))
    
    /// A network client that always fails with FakeIlpError.unauthenticatedError
    static let unauthenticatedPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.unauthenticatedError))
    
    /// A network client that always fails with FakeIlpError.invalidArgumentError
    static let invalidArgumentPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.invalidArgumentError))
    
    /// A network client that always fails with FakeIlpError.internalError
    static let internalErrorPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(FakeIlpError.internalError))
    
    /// A network client that always fails with IlpError.invalidAccessToken
    static let invalidAccessTokenPaymentNetworkClient = FakeIlpPaymentNetworkClient(sendPaymentResult: .failure(IlpError.invalidAccessToken))
}
