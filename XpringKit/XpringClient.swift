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
		let accountInfo = try getAccountInfo(for: address)
		return accountInfo.balance
	}
	
	/// Send some XRP!
	public func send(_ amount: Io_Xpring_XRPAmount, to destinationAddress: Address, from sourceWallet: Wallet) throws -> Io_Xpring_SubmitSignedTransactionResponse {
		let accountInfo = try getAccountInfo(for: sourceWallet.address)
		let fee = try getFee()
	}
	
	private func getFee() throws -> Io_Xpring_Fee {
		let getFeeRequest = Io_Xpring_GetFeeRequest()
		return networkClient.getFee(getFeeRequest)
	}
	
	private func getAccountInfo(for address: Address) throws -> Io_Xpring_AccountInfo {
		let getAccountInfoRequest = Io_Xpring_GetAccountInfoRequest.with {
			$0.address = address
		}
		
		return try networkClient.getAccountInfo(getAccountInfoRequest)
	}
}
