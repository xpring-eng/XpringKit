import BigInt

/// An interface into the Xpring Platform.
public class DefaultXpringClient {
  /// A network client that will make and receive requests.
  private let networkClient: NetworkClient

  /// Initialize a new XpringClient.
  ///
  /// - Parameter grpcURL: A url for a remote gRPC service which will handle network requests.
  public convenience init(grpcURL: String) {
    let networkClient = Rpc_V1_XRPLedgerAPIServiceServiceClient(address: grpcURL, secure: false)
    self.init(networkClient: networkClient)
  }

  /// Initialize a new XpringClient.
  ///
  /// - Parameter networkClient: A network client which will make requests.
  internal init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  /// Retrieve the current fee to submit a transaction to the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Rpc_V1_XRPDropsAmount` for submitting a transaction to the ledger.
  private func getFee() throws -> Rpc_V1_XRPDropsAmount {
    let getFeeResponse = try getRawFee()
    return getFeeResponse.drops.minimumFee
  }

  /// Retrieve a raw `GetFeeResponse` from the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Rpc_V1_XRPDropsAmount` for submitting a transaction to the ledger.
  private func getRawFee() throws -> Rpc_V1_GetFeeResponse {
    let getFeeRequest = Rpc_V1_GetFeeRequest()
    return try networkClient.getFee(getFeeRequest)
  }

  /// Retrieve Account Info from the XRP Ledger.
  ///
  /// - Parameter classicAddress: The classic address to retrieve info for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Rpc_V1_AccountInfo` for submitting a transaction to the ledger.
  private func getAccountInfo(for classicAddress: Address) throws -> Rpc_V1_GetAccountInfoResponse {
    let accountInfoRequest = Rpc_V1_GetAccountInfoRequest.with {
      $0.account = Rpc_V1_AccountAddress.with {
        $0.address = classicAddress
      }
    }
    return try networkClient.getAccountInfo(accountInfoRequest)
  }
}

extension DefaultXpringClient: XpringClientDecorator {
  /// Get the balance for the given address.
  ///
  /// - Parameter address: The X-Address to retrieve the balance for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: An unsigned integer containing the balance of the address in drops.
  public func getBalance(for address: Address) throws -> BigUInt {
    guard
      let classicAddressComponents = Utils.decode(xAddress: address)
    else {
      throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }
    let accountInfoResponse = try getAccountInfo(for: classicAddressComponents.classicAddress)

    return BigUInt(accountInfoResponse.accountData.balance.drops)
  }

  /// Retrieve the transaction status for a given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    throw XRPLedgerError.unimplemented
  }

  /// Send XRP to a recipient on the XRP Ledger.
  ///
  /// - Parameters:
  ///    - amount: An unsigned integer representing the amount of XRP to send.
  ///    - destinationAddress: The X-Address which will receive the XRP.
  ///    - sourceWallet: The wallet sending the XRP.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
  /// - Returns: A transaction hash for the submitted transaction.
  public func send(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    throw XRPLedgerError.unimplemented
  }

  /// Retrieve the latest validated ledger sequence on the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The index of the latest validated ledger.
  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    let getFeeResponse = try getRawFee()
    return getFeeResponse.ledgerCurrentIndex
  }

  /// Retrieve the raw transaction status for the given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionStatus {
    throw XRPLedgerError.unimplemented
  }
}
