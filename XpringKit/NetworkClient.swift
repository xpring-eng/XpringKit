/// A client which can make requests to the Xpring Network.
public protocol NetworkClient {
    /// Get an account info object.
    ///
    /// - Parameter request: Request parameters for an account info.
    /// - Throws: An error if there was a problem communicating with the Xpring Network.
    /// - Returns: An AccountInfo object that corresponds to the request.
    func getAccountInfo(_ request: AccountInfoRequest) throws -> AccountInfo
}
