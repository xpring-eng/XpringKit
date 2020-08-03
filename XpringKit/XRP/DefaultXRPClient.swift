import Foundation
import SwiftGRPC

/// An interface into the Xpring Platform.
public class DefaultXRPClient {
  /// A margin to pad the current ledger sequence with when submitting transactions.
  private let maxLedgerVersionOffset: UInt32 = 10

  /// The XRPL network this XRPClient is connecting to.
  internal let network: XRPLNetwork

  /// A network client that will make and receive requests.
  private let networkClient: NetworkClient

  /// Initialize a new XRPClient.
  ///
  /// - Parameter grpcURL: A url for a remote gRPC service which will handle network requests.
  public convenience init(grpcURL: String, xrplNetwork: XRPLNetwork) {
    let networkClient = Org_Xrpl_Rpc_V1_XRPLedgerAPIServiceServiceClient(address: grpcURL, secure: false)
    self.init(networkClient: networkClient, xrplNetwork: xrplNetwork)
  }

  /// Initialize a new XRPClient.
  ///
  /// - Parameter networkClient: A network client which will make requests.
  internal init(networkClient: NetworkClient, xrplNetwork: XRPLNetwork) {
    self.networkClient = networkClient
    self.network = xrplNetwork
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
      $0.ledger = Org_Xrpl_Rpc_V1_LedgerSpecifier.with {
        $0.shortcut = Org_Xrpl_Rpc_V1_LedgerSpecifier.Shortcut.validated
      }
    }
    return try networkClient.getAccountInfo(accountInfoRequest)
  }
}

extension DefaultXRPClient: XRPClientDecorator {
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

  /// Retrieve the transaction status for a Payment given transaction hash.
  ///
  /// - Note: This method will only work for Payment type transactions which do not have the tf_partial_payment
  ///         attribute set.
  /// - SeeAlso: https://xrpl.org/payment.html#payment-flags
  ///
  /// - Parameter transactionHash The hash of the transaction.
  /// - Returns: The status of the given transaction.
  public func paymentStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
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
  public func send(
    _ amount: UInt64,
    to destinationAddress: Address,
    from sourceWallet: Wallet
  ) throws -> TransactionHash {
    guard
      Utils.decode(xAddress: destinationAddress) != nil
      else {
        throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    let payment = Org_Xrpl_Rpc_V1_Payment.with {
      $0.destination = Org_Xrpl_Rpc_V1_Destination.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = destinationAddress
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

    var transaction = try  self.prepareBaseTransaction(wallet: sourceWallet)

    transaction.payment = payment

    return try self.signAndSubmitTransaction(transaction: transaction, wallet: sourceWallet)
  }

  /// Retrieve the open ledger sequence index.
  ///
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The index of the open ledger.
  private func getOpenLedgerSequence() throws -> UInt32 {
    // The fee API response contains the last ledger sequence and a limited subset of RPCs were implemented in gRPC.
    let getFeeResponse = try getRawFee()
    return getFeeResponse.ledgerCurrentIndex
  }

  /// Retrieve the latest validated ledger sequence on the XRP Ledger.
  ///
  /// - Note: This call will throw if the given account does not exist on the ledger at the current time. It is the
  /// *caller's responsibility* to ensure this invariant is met.
  /// - Note: The input address *must* be in a classic address form. Inputs are not checked to this internal method.
  ///
  /// TODO(keefertaylor): The above requirements are onerous, difficult to reason about and the logic of this method is\
  /// brittle. Replace this method's implementation when rippled supports a `ledger` RPC via gRPC.
  ///
  /// - Parameter address: An address that exists at the current time. The address is unchecked and must be
  ///   a classic address.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: The index of the latest validated ledger.
  internal func getLatestValidatedLedgerSequence(address: Address) throws -> UInt32 {
    // rippled doesn't support a gRPC call that tells us the latest validated ledger sequence. To get around this,
    // query the account info for an account which will exist, using a shortcut for the latest validated ledger. The
    // response will contain the ledger index the information was retrieved at.
    let getAccountInfoRequest = Org_Xrpl_Rpc_V1_GetAccountInfoRequest.with {
      $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = address
      }
      $0.ledger = Org_Xrpl_Rpc_V1_LedgerSpecifier.with {
        $0.shortcut = Org_Xrpl_Rpc_V1_LedgerSpecifier.Shortcut.validated
      }
    }

    let getAccountInfoResponse = try networkClient.getAccountInfo(getAccountInfoRequest)
    return getAccountInfoResponse.ledgerIndex
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

  /// Check if an address exists on the XRP Ledger
  ///
  /// - Parameter address: The address to check the existence of.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A boolean if the account is on the blockchain.
  public func accountExists(for address: Address) throws -> Bool {
    guard
      Utils.decode(xAddress: address) != nil
    else {
      throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    do {
      try _ = self.getBalance(for: address)
      return true
    } catch RPCError.callError(let callResult) {
      if callResult.statusCode == StatusCode.notFound {
        return false
      }
      throw RPCError.callError(callResult) // otherwise, an RPCError with unexpected statusCode, re-throw
    } catch {
      throw error // any other type of Error, re-throw
    }
  }

  /// Return the history of payments for the given account.
  ///
  /// - Note: This method only works for payment type transactions, see: https://xrpl.org/payment.html
  /// - Note: This method only returns the history that is contained on the remote node, which may not contain a full
  ///         history of the network.
  ///
  /// - Parameter address: The address (account) for which to retrive payment history.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: An array of payments associated with the account.
  public func paymentHistory(for address: Address) throws -> [XRPTransaction] {
    guard
      let classicAddressComponents = Utils.decode(xAddress: address)
      else {
        throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    let request = Org_Xrpl_Rpc_V1_GetAccountTransactionHistoryRequest.with {
      $0.account = Org_Xrpl_Rpc_V1_AccountAddress.with {
        $0.address = classicAddressComponents.classicAddress
      }
    }

    let transactionHistory = try self.networkClient.getAccountTransactionHistory(request)

    let transactionResponses = transactionHistory.transactions

    // Filter transactions to payments only and convert them to XRPTransactions.
    // If a payment transaction fails conversion, throw an error.
    return try transactionResponses.compactMap { transactionResponse in
      let transaction = transactionResponse.transaction

      switch transaction.transactionData {
      case .payment:
        // If a payment can't be converted throw an error to prevent returning incomplete data.
        guard let xrpTransaction = XRPTransaction(
          getTransactionResponse: transactionResponse,
          xrplNetwork: self.network
        )
        else {
          throw XRPLedgerError.unknown(
            "Could not convert payment transaction: \(transaction). " +
            "Please file a bug at https://github.com/xpring-eng/xpringkit"
          )
        }
        return xrpTransaction
      default:
        // Other transaction types are not support.
        return nil
      }
    }
  }

  /// Retrieve the payment transaction corresponding to the given transaction hash.
  ///
  /// - Note: This method can return transactions that are not included in a fully validated ledger.
  ///         See the `validated` field to make this distinction.
  ///
  /// - Parameter transactionHash: The hash of the transaction to retrieve.
  /// - Throws: An RPCError if the transaction hash was invalid.
  /// - Returns: An XRPTransaction object representing an XRP Ledger transaction.
  public func getPayment(for transactionHash: String) throws -> XRPTransaction? {
    let transactionHashBytes = try transactionHash.toBytes()
    let transactionHashData = Data(transactionHashBytes)

    let request = Org_Xrpl_Rpc_V1_GetTransactionRequest.with {
      $0.hash = transactionHashData
    }

    let getTransactionResponse = try self.networkClient.getTransaction(request)

    return XRPTransaction(getTransactionResponse: getTransactionResponse, xrplNetwork: self.network)
  }

  /// Enable Deposit Authorization for this XRPL account.
  /// - seeAlso: https://xrpl.org/depositauth.html
  ///
  /// - Parameter wallet: The wallet associated with the XRPL account enabling Deposit Authorization and that will
  ///                     sign the request.
  /// - Throws: An error if there was a problem communicating with the XRP Ledger.
  /// - Returns: A TransactionResult object that contains the hash of the submitted AccountSet transaction and the
  ///            final status of the transaction.
  public func enableDepositAuth(for wallet: Wallet) throws -> TransactionResult {
    let setFlag = Org_Xrpl_Rpc_V1_SetFlag.with {
      $0.value = AccountSetFlag.asfDepositAuth.rawValue
    }

    let accountSet = Org_Xrpl_Rpc_V1_AccountSet.with {
      $0.setFlag = setFlag
    }

    var transaction = try self.prepareBaseTransaction(wallet: wallet)
    transaction.accountSet = accountSet

    let transactionHash = try self.signAndSubmitTransaction(transaction: transaction, wallet: wallet)
    let status = try self.paymentStatus(for: transactionHash)
    let rawStatus = try self.getRawTransactionStatus(for: transactionHash)

    return TransactionResult(hash: transactionHash, status: status, validated: rawStatus.validated)
  }

  /// Populates the required fields common to all transaction types.
  ///
  /// - SeeAlso: https://xrpl.org/transaction-common-fields.html
  ///
  /// Note: The returned Transaction object must still be assigned transaction-specific details.
  /// Some transaction types require a different fee (or no fee), in which case the fee should be overwritten
  /// appropriately when constructing the transaction-specific details.
  /// - SeeAlso: https://xrpl.org/transaction-cost.html
  ///
  /// - Parameter wallet: The wallet that will sign and submit this transaction.
  /// - Returns: A Transaction protobuf with the required common fields populated.
  ///
  private func prepareBaseTransaction(wallet: Wallet) throws -> Org_Xrpl_Rpc_V1_Transaction {
    guard
      let sourceClassicAddressComponents = Utils.decode(xAddress: wallet.address)
      else {
        throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
    }

    let accountInfo = try getAccountInfo(for: sourceClassicAddressComponents.classicAddress)
    let fee = try getFee()
    let lastValidatedLedgerSequence = try getOpenLedgerSequence()

    let signingPublicKeyBytes = try wallet.publicKey.toBytes()

    let transaction = Org_Xrpl_Rpc_V1_Transaction.with {
      $0.account = Org_Xrpl_Rpc_V1_Account.with {
        $0.value = Org_Xrpl_Rpc_V1_AccountAddress.with {
          $0.address = sourceClassicAddressComponents.classicAddress
        }
      }

      $0.fee = fee
      $0.sequence = accountInfo.accountData.sequence

      $0.lastLedgerSequence = Org_Xrpl_Rpc_V1_LastLedgerSequence.with {
        $0.value = lastValidatedLedgerSequence + maxLedgerVersionOffset
      }
      $0.signingPublicKey = Org_Xrpl_Rpc_V1_SigningPublicKey.with {
        $0.value = Data(signingPublicKeyBytes)
      }
    }

    return transaction
  }

  /// Signs the provided transaction using the wallet and submits to the XRPL network.
  ///
  /// - Parameters:
  ///   - transaction: The transaction to be signed and submitted.
  ///   - wallet: The wallet that will sign and submit this transaction.
  /// - Returns: a string representing the hash of the submitted transaction.
  ///
  private func signAndSubmitTransaction(transaction: Org_Xrpl_Rpc_V1_Transaction, wallet: Wallet) throws -> String {
    guard let signedTransaction = Signer.sign(transaction, with: wallet) else {
      throw XRPLedgerError.signingError
    }

    let submitTransactionRequest = Org_Xrpl_Rpc_V1_SubmitTransactionRequest.with {
      $0.signedTransaction = Data(signedTransaction)
    }

    let submitTransactionResponse = try networkClient.submitTransaction(submitTransactionRequest)

    return [UInt8](submitTransactionResponse.hash).toHex()
  }
}
