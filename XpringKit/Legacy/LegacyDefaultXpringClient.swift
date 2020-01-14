import BigInt

/// An interface into the Xpring Platform.
public class LegacyDefaultXpringClient {
  /// A margin to pad the current ledger sequence with when submitting transactions.
  private let ledgerSequenceMargin: UInt32 = 10

  /// A network client that will make and receive requests.
	private let networkClient: LegacyNetworkClient

  /// Initialize a new XRPClient.
  ///
  /// - Parameter grpcURL: A url for a remote gRPC service which will handle network requests.
	public convenience init(grpcURL: String) {
		let networkClient = Io_Xpring_XRPLedgerAPIServiceClient(address: grpcURL, secure: false)
		self.init(networkClient: networkClient)
	}

	/// Initialize a new XRPClient.
	///
	/// - Parameter networkClient: A network client which will make requests.
	internal init(networkClient: LegacyNetworkClient) {
		self.networkClient = networkClient
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

  /// Retrieve the current fee to submit a transaction to the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Fee` for submitting a transaction to the ledger.
  private func getFee() throws -> Io_Xpring_Fee {
    let getFeeRequest = Io_Xpring_GetFeeRequest()
    return try networkClient.getFee(getFeeRequest)
  }
}

extension LegacyDefaultXpringClient: LegacyXpringClientDecorator {
	/// Get the balance for the given address.
	///
	/// - Parameter address: The X-Address to retrieve the balance for.
	/// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
	/// - Returns: An unsigned integer containing the balance of the address in drops.
	public func getBalance(for address: Address) throws -> BigUInt {
    guard Utils.isValidXAddress(address: address) else {
      throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

		let accountInfo = try getAccountInfo(for: address)
    return BigUInt(stringLiteral: accountInfo.balance.drops)
	}

  /// Retrieve the transaction status for a given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    let transactionStatus = try getRawTransactionStatus(for: transactionHash)

    // Return pending if the transaction is not validated.
    guard transactionStatus.validated else {
      return .pending
    }
    return transactionStatus.transactionStatusCode.starts(with: "tes") ? .succeeded : .failed
  }

	/// Send XRP to a recipient on the XRP Ledger.
	///
	/// - Parameters:
	///		- amount: An unsigned integer representing the amount of XRP to send.
	///		- destinationAddress: The X-Address which will receive the XRP.
	///		- sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
	/// - Returns: A transaction hash for the submitted transaction.
	public func send(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    guard Utils.isValidXAddress(address: destinationAddress) else {
      throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    let accountInfo = try getAccountInfo(for: sourceWallet.address)
    let fee = try getFee()
    let lastValidatedLedgerSequence = try getLatestValidatedLedgerSequence()

    let xrpAmount = Io_Xpring_XRPAmount.with {
      $0.drops = String(amount)
    }

    let transaction = Io_Xpring_Transaction.with {
      $0.account = sourceWallet.address
      $0.fee = fee.amount
      $0.sequence = accountInfo.sequence
      $0.payment = Io_Xpring_Payment.with {
        $0.destination = destinationAddress
        $0.xrpAmount = xrpAmount
      }
      $0.signingPublicKeyHex = sourceWallet.publicKey
      $0.lastLedgerSequence = lastValidatedLedgerSequence + ledgerSequenceMargin
    }

    guard let signedTransaction = LegacySigner.sign(transaction, with: sourceWallet) else {
      throw XRPLedgerError.signingError
    }

    let submitSignedTransactionRequest = Io_Xpring_SubmitSignedTransactionRequest.with {
      $0.signedTransaction = signedTransaction
    }

    let submitTransactionResponse = try networkClient.submitSignedTransaction(submitSignedTransactionRequest)
    guard let hash = Utils.toTransactionHash(transactionBlobHex: submitTransactionResponse.transactionBlob) else {
      throw XRPLedgerError.unknown("Could not hash transaction blob: \(submitTransactionResponse.transactionBlob)")
    }
    return hash
  }

  /// Retrieve the latest validated ledger sequence on the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The index of the latest validated ledger.
  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    let getLatestValidatedLedgerSequenceRequest = Io_Xpring_GetLatestValidatedLedgerSequenceRequest()
    let ledgerSequence = try networkClient.getLatestValidatedLedgerSequence(getLatestValidatedLedgerSequenceRequest)
    return UInt32(ledgerSequence.index)
  }

  /// Retrieve the raw transaction status for the given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionStatus {
    let transactionStatusRequest = Io_Xpring_GetTransactionStatusRequest.with { $0.transactionHash = transactionHash }
    return try networkClient.getTransactionStatus(transactionStatusRequest)
  }
}
