import BigInt
import Foundation

/// An interface into the Xpring Platform.
public class DefaultXpringClient {
    /// A margin to pad the current ledger sequence with when submitting transactions.
    private let ledgerSequenceMargin: UInt32 = 10

    /// A network client that will make and receive requests.
    private let networkClient: NetworkClient

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
    internal init(networkClient: NetworkClient) {
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

extension DefaultXpringClient: XpringClientDecorator {
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
        return BigUInt(accountInfo.balance.drops)
    }

//    /// Retrieve the transaction data for a given transaction hash.
//    ///
//    /// - Parameter transactionHash: The hash of the transaction.
//    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
//    /// - Returns: The data of the given transaction.
//    public func getTransactionData(for transactionHash: TransactionHash) throws -> TransactionData {
//        // TODO: Guard Something...
////        guard Utils.isValidXAddress(address: destinationAddress) else {
////            throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
////        }
//        let transactionData = try getRawTransactionData(for: transactionHash)
//        return transactionData
//    }

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
    /// - Returns: A signed transaction for submission on the XRP Ledger.
    public func sign(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet, invoiceID: Data?, memos: [Io_Xpring_Memo]?, flags: UInt32?, sourceTag: UInt32?, accountTransactionID: Data?) throws -> Io_Xpring_SignedTransaction {
        guard Utils.isValidXAddress(address: destinationAddress) else {
            throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
        }

        let accountInfo = try getAccountInfo(for: sourceWallet.address)
        let fee = try getFee()
        let lastValidatedLedgerSequence = try getLatestValidatedLedgerSequence()

        let dropsAount = Io_Xpring_XRPDropsAmount.with {
            $0.drops = UInt64(amount)
        }

        let xrpAmount = Io_Xpring_CurrencyAmount.with {
            $0.xrpAmount = dropsAount
        }

        let _sender = Io_Xpring_AccountAddress.with {
            $0.address = sourceWallet.address
        }

        let _destination = Io_Xpring_AccountAddress.with {
            $0.address = destinationAddress
        }

        let transaction = Io_Xpring_Transaction.with {
            $0.account = _sender
            $0.fee = fee.amount
            $0.sequence = UInt32(accountInfo.sequence)
            $0.payment = Io_Xpring_Payment.with {
                if let _invoiceID = invoiceID {
                    $0.invoiceID = _invoiceID
                }
                $0.destination = _destination
                $0.amount = xrpAmount
            }
            if let _memos = memos {
                $0.memos = _memos
            }
            if let _flags = flags {
                $0.flags = _flags
            }
            if let _sourceTag = sourceTag {
                $0.sourceTag = _sourceTag
            }
            if let _accountTransactionID = accountTransactionID {
                $0.accountTransactionID = _accountTransactionID
            }
            // Format For Hex
//            $0.signingPublicKey = sourceWallet.publicKey
            $0.lastLedgerSequence = lastValidatedLedgerSequence + ledgerSequenceMargin
        }

        guard let signedTransaction = Signer.sign(transaction, with: sourceWallet) else {
            throw XRPLedgerError.signingError
        }

        return signedTransaction
    }

    /// SSend XRP to a recipient on the XRP Ledger.
    ///
    /// - Parameters:
    ///        - amount: An unsigned integer representing the amount of XRP to send.
    ///        - destinationAddress: The X-Address which will receive the XRP.
    ///        - sourceWallet: The wallet sending the XRP.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger or the inputs were invalid.
    /// - Returns: A transaction hash for the submitted transaction.
    public func send(_ signedTransaction: Io_Xpring_SignedTransaction) throws -> TransactionHash {

        let submitSignedTransactionRequest = Io_Xpring_SubmitSignedTransactionRequest.with {
            $0.signedTransaction = signedTransaction
        }

        let submitTransactionResponse = try networkClient.submitSignedTransaction(submitSignedTransactionRequest)
        guard let hash = Utils.toTransactionHash(transactionBlobHex: submitTransactionResponse.transactionBlob) else {
            throw XRPLedgerError.unknown(
                "Could not hash transaction blob: \(submitTransactionResponse.transactionBlob)"
            )
        }

        var newTransaction = signedTransaction.transaction
//        newTransaction.hash = hash

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

//    /// Retrieve the raw transaction status for the given transaction hash.
//    ///
//    /// - Parameter transactionHash: The hash of the transaction.
//    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
//    /// - Returns: The status of the given transaction.
//    public func getRawTransactionData(for transactionHash: TransactionHash) throws -> Io_Xpring_TransactionData {
//        let transactionDataRequest = Io_Xpring_GetTransactionDataRequest.with { $0.transactionHash = transactionHash }
//        return try networkClient.getTransactionData(transactionDataRequest)
//    }

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
