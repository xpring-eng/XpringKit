/// TODO: make this compile, move, name appropriately
public enum XpringClientError: Error {
	case signingError
}

/// An interface into the Xpring Platform.
/// TODO(keefertaylor): Rename this to XRPClient.
public class XpringClient {
	/// A network client that will make and receive requests.
	private let networkClient: NetworkClient

	/// Initialize a new XRPClient.
	///
	/// - Parameter grpcURL: A url for a remote gRPC service which will handle network requests.
	public convenience init(grpcURL: String) {
		let networkClient = Io_Xpring_XRPLedgerServiceClient(address: grpcURL, secure: false)
		self.init(networkClient: networkClient)
	}

	/// Initialize a new XRPClient.
	///
	/// - Parameter networkClient: A network client which will make requests.
	internal init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}

	/// Get the balance for the given address.
	///
	/// - Parameter address: The address to retrieve the balance for.
	/// - Throws: An error if there was a problem communicating with the XRP Ledger.
	/// - Returns: An XRPAmount containing the balance of the address.
	public func getBalance(for address: Address) throws -> Io_Xpring_XRPAmount {
		let accountInfo = try getAccountInfo(for: address)
		return accountInfo.balance
	}

	/// Send XRP to a recipient on the XRP Ledger.
	///
	/// - Parameters:
	///		- amount: The amount of XRP to send.
	///		- destinationAddress: The address which will receive the XRP.
	///		- sourceWallet: The wallet sending the XRP.
	/// - Throws: An error if there was a problem communicating with the XRP Ledger.
	/// - Returns: A response from the ledger.
	public func send(_ amount: Io_Xpring_XRPAmount, to destinationAddress: Address, from sourceWallet: Wallet) throws -> Io_Xpring_SubmitSignedTransactionResponse {
		let accountInfo = try getAccountInfo(for: sourceWallet.address)
		let fee = try getFee()

		let transaction = Io_Xpring_Transaction.with {
			$0.account = sourceWallet.address
			$0.fee = fee.amount
			$0.sequence = accountInfo.sequence
			$0.payment = Io_Xpring_Payment.with {
				$0.destination = destinationAddress
				$0.xrpAmount = amount
			}
			$0.signingPublicKeyHex = sourceWallet.publicKey
		}

		guard let signedTransaction = Signer.sign(transaction, with: sourceWallet) else {
			throw XpringClientError.signingError
		}

		let submitSignedTransactionRequest = Io_Xpring_SubmitSignedTransactionRequest.with {
			$0.signedTransaction = signedTransaction
		}

		return try networkClient.submitSignedTransaction(submitSignedTransactionRequest)
	}

	/// Retrieve the current fee to submit a transaction to the XRP Ledger.
	///
	/// - Throws: An error if there was a problem communicating with the XRP Ledger.
	/// - Returns: A `Fee` for submitting a transaction to the ledger.
	private func getFee() throws -> Io_Xpring_Fee {
		let getFeeRequest = Io_Xpring_GetFeeRequest()
		return try networkClient.getFee(getFeeRequest)
	}

	/// Retrieve an `AccountInfo` for an address on the XRP Ledger.
	///
	/// - Parameter address: The address to retrieve information about.
	/// - Throws: An error if there was a problem communicating with the XRP Ledger.
	/// - Returns: An `AccountInfo` containing data about the given address.
	private func getAccountInfo(for address: Address) throws -> Io_Xpring_AccountInfo {
		let getAccountInfoRequest = Io_Xpring_GetAccountInfoRequest.with {
			$0.address = address
		}

		return try networkClient.getAccountInfo(getAccountInfoRequest)
	}
}
