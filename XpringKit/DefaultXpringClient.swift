import Foundation

/// An interface into the Xpring Platform.
public class DefaultXpringClient {
  /// A margin to pad the current ledger sequence with when submitting transactions.
  private let maxLedgerVersionOffset: UInt32 = 10

  /// A network client that will make and receive requests.
  private let networkClient: NetworkClient

  /// Initialize a new XpringClient.
  ///
  /// - Parameter grpcURL: A url for a remote gRPC service which will handle network requests.
  public convenience init(grpcURL: String) {
    let networkClient = Org_Xrpl_Rpc_V1_XRPLedgerAPIServiceServiceClient(address: grpcURL, secure: false)
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
  /// - Returns: A `Org_Xrpl_Rpc_V1_XRPDropsAmount` for submitting a transaction to the ledger.
  private func getFee() throws -> Org_Xrpl_Rpc_V1_XRPDropsAmount {
    let getFeeResponse = try getRawFee()
    return getFeeResponse.fee.minimumFee
  }

  /// Retrieve a raw `GetFeeResponse` from the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Org_Xrpl_Rpc_V1_XRPDropsAmount` for submitting a transaction to the ledger.
  private func getRawFee() throws -> Org_Xrpl_Rpc_V1_GetFeeResponse {
    let getFeeRequest = Org_Xrpl_Rpc_V1_GetFeeRequest()
    return try networkClient.getFee(getFeeRequest)
  }

  /// Retrieve Account Info from the XRP Ledger.
  ///
  /// - Parameter classicAddress: The classic address to retrieve info for.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A `Org_Xrpl_Rpc_V1_AccountInfo` for submitting a transaction to the ledger.
  private func getAccountInfo(for classicAddress: Address) throws -> Org_Xrpl_Rpc_V1_GetAccountInfoResponse {
    let accountInfoRequest = Org_Xrpl_Rpc_V1_GetAccountInfoRequest.with {
      $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
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
  public func getBalance(for address: Address) throws -> UInt64 {
    guard
      let classicAddressComponents = Utils.decode(xAddress: address)
    else {
      throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    let accountInfoResponse = try self.getAccountInfo(for: classicAddressComponents.classicAddress)

    return accountInfoResponse.accountData.balance.value.xrpAmount.drops
  }

  /// Retrieve the transaction status for a given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
    let transactionStatus = try getRawTransactionStatus(for: transactionHash)

    // Only full payment transactions can be bucketed.
    guard transactionStatus.isFullPayment else {
      return .unknown
    }

    // Return pending if the transaction is not validated.
    guard transactionStatus.validated else {
      return .pending
    }
    return transactionStatus.transactionStatusCode.starts(with: "tes") ? .succeeded : .failed
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
    guard
      let destinationClassicAddressComponents = Utils.decode(xAddress: destinationAddress),
      let sourceClassicAddressComponents = Utils.decode(xAddress: sourceWallet.address)
    else {
      throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    let accountInfo = try getAccountInfo(for: sourceClassicAddressComponents.classicAddress)
    let fee = try getFee()
    let lastValidatedLedgerSequence = try getLatestValidatedLedgerSequence()

    var payment = Org_Xrpl_Rpc_V1_Payment.with {
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = destinationClassicAddressComponents.classicAddress
        }
      }

      $0.amount = Org_Xrpl_Rpc_V1_Amount.with {
        $0.value = Org_Xrpl_Rpc_V1_CurrencyAmount.with {
          $0.xrpAmount = Org_Xrpl_Rpc_V1_XRPDropsAmount.with {
            $0.drops = amount
          }
        }
      }
    }
    if let destinationTag = destinationClassicAddressComponents.tag {
      payment.destinationTag = Org_Xrpl_Rpc_V1_DestinationTag.with {
        $0.value = destinationTag
      }
    }

    let signingPublicKeyBytes = try sourceWallet.publicKey.toBytes()

    let transaction = Org_Xrpl_Rpc_V1_Transaction.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = sourceClassicAddressComponents.classicAddress
        }
      }

      $0.fee = fee
      $0.sequence = accountInfo.accountData.sequence
      $0.payment = payment

      $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
        $0.value = lastValidatedLedgerSequence + maxLedgerVersionOffset
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = Data(signingPublicKeyBytes)
      }
    }

    guard let signedTransaction = Signer.sign(transaction, with: sourceWallet) else {
      throw XRPLedgerError.signingError
    }

    let submitTransactionRequest = Org_Xrpl_Rpc_V1_SubmitTransactionRequest.with {
      $0.signedTransaction = Data(signedTransaction)
    }

    let submitTransactionResponse = try networkClient.submitTransaction(submitTransactionRequest)

    return [UInt8](submitTransactionResponse.hash).toHex()
  }

  /// Retrieve the latest validated ledger sequence on the XRP Ledger.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The index of the latest validated ledger.
  public func getLatestValidatedLedgerSequence() throws -> UInt32 {
    // The fee API response contains the last ledger sequence and a limited subset of RPCs were implemented in gRPC.
    let getFeeResponse = try getRawFee()
    return getFeeResponse.ledgerCurrentIndex
  }

  /// Retrieve the raw transaction status for the given transaction hash.
  ///
  /// - Parameter transactionHash: The hash of the transaction.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The status of the given transaction.
  public func getRawTransactionStatus(for transactionHash: TransactionHash) throws -> RawTransactionStatus {
    let transactionHashBytes = try transactionHash.toBytes()
    let transactionHashData = Data(transactionHashBytes)

    let request = Org_Xrpl_Rpc_V1_GetTransactionRequest.with {
      $0.hash = transactionHashData
    }

    let getTransactionResponse = try self.networkClient.getTransaction(request)

    return RawTransactionStatus(getTransactionResponse: getTransactionResponse)
  }
}
