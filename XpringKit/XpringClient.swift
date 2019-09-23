/// An interface into the Xpring Platform.
public class XpringClient {
	/// A network client that will make and receive requests.
	private let networkClient: NetworkClient

	private let signer: Signer

	public init(networkClient: NetworkClient) {
		self.networkClient = networkClient
		self.signer = Signer()
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

		let transaction = Io_Xpring_Transaction.with {
			$0.account = sourceWallet.address
			$0.fee = fee.amount
			// TODO: These types should align.
			$0.sequence = UInt64(accountInfo.sequence)
			$0.payment = Io_Xpring_Payment.with {
				$0.destination = destinationAddress
				$0.xrpAmount = amount
			}
			$0.signingPublicKeyHex = sourceWallet.publicKey
		}

		guard let signedTransaction = signer.sign(transaction, with: sourceWallet) else {
			fatalError()
		}
		let submitSignedTransactionRequest = Io_Xpring_SubmitSignedTransactionRequest.with {
			$0.signedTransaction = signedTransaction
		}

		return try networkClient.submitSignedTransaction(submitSignedTransactionRequest)
	}

	private func getFee() throws -> Io_Xpring_Fee {
		let getFeeRequest = Io_Xpring_GetFeeRequest()
		return try networkClient.getFee(getFeeRequest)
	}

	private func getAccountInfo(for address: Address) throws -> Io_Xpring_AccountInfo {
		let getAccountInfoRequest = Io_Xpring_GetAccountInfoRequest.with {
			$0.address = address
		}

		return try networkClient.getAccountInfo(getAccountInfoRequest)
	}
}
