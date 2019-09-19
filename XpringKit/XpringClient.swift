/// An interface into the Xpring Platform.
public class XpringClient {
	/// A network client that will make and receive requests.
	private let networkClient: NetworkClient

	public init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}

	/// Get the balance for the given address.
	///
	/// - Parameter address: The address to retrieve the balance for.
	/// - Throws: An error if there was a problem communicating to the Xpring Network.
	/// - Returns: An XRPAmount containing the balance of the address.
	public func getBalance(for address: Address) throws -> Io_Xpring_XRPAmount {
		let getAccountInfoRequest = Io_Xpring_GetAccountInfoRequest.with {
			$0.address = address
		}

		let accountInfo = try networkClient.getAccountInfo(getAccountInfoRequest)
		return accountInfo.balance
	}
}
