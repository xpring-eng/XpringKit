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
  /// - Returns: A `Fee` for submitting a transaction to the ledger.
  private func getFee() throws -> Rpc_V1_XRPDropsAmount {
    let getFeeRequest = Rpc_V1_GetFeeRequest()

    let getFeeResponse = try networkClient.getFee(getFeeRequest)

    return getFeeResponse.drops.minimumFee
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

    let accountInfoRequest = Rpc_V1_GetAccountInfoRequest.with {
      $0.account = Rpc_V1_AccountAddress.with {
        $0.address = classicAddressComponents.classicAddress
      }
    }

    let accountInfoResponse = try networkClient.getAccountInfo(accountInfoRequest)

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
  public func send(_ amount: UInt64, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    throw XRPLedgerError.unimplemented
  }

  /// Retrieve the latest validated ledger sequence on the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The index of the latest validated ledger.
  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    throw XRPLedgerError.unimplemented
  }

  /// Retrieve the raw transaction status for the given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    throw XRPLedgerError.unimplemented
  }
}
