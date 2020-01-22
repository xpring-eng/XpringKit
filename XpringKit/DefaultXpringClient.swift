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
        let networkClient = Rpc_V1_XRPLedgerAPIServiceServiceClient(address: grpcURL, secure: false)
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
    private func getAccountInfo(for address: Address) throws -> Rpc_V1_AccountRoot {
        let account = Rpc_V1_AccountAddress.with {
            $0.address = Utils.decode(xAddress: address)!.classicAddress
        }
        let getAccountInfoRequest = Rpc_V1_GetAccountInfoRequest.with {
            $0.account = account
        }
        let resp = try networkClient.getAccountInfo(getAccountInfoRequest)
        return resp.accountData
    }

    /// Retrieve the current fee to submit a transaction to the XRP Ledger.
    ///
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: A `Fee` for submitting a transaction to the ledger.
    private func getFee() throws -> Rpc_V1_GetFeeResponse {
        let getFeeRequest = Rpc_V1_GetFeeRequest()
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

    /// Retrieve the transaction status for a given transaction hash.
    ///
    /// - Parameter transactionHash: The hash of the transaction.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The status of the given transaction.
    public func getTransactionStatus(for transactionHash: TransactionHash) throws -> TransactionStatus {
        let transaction = try getRawTx(for: transactionHash)

        // Return pending if the transaction is not validated.
        guard transaction.validated else {
            return .pending
        }

        return transaction.meta.transactionResult.resultType == .tes ? .succeeded : .failed
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

        guard Utils.isValidXAddress(address: destinationAddress) else {
            throw XRPLedgerError.invalidInputs("Please use the X-Address format. See: https://xrpaddress.info/.")
        }

        let accountInfo = try getAccountInfo(for: sourceWallet.address)
        let fee = try getFee()
        let lastValidatedLedgerSequence = accountInfo.sequence

        let dropsAount = Rpc_V1_XRPDropsAmount.with {
            $0.drops = UInt64(amount)
        }

        let xrpAmount = Rpc_V1_CurrencyAmount.with {
            $0.xrpAmount = dropsAount
        }

        let _sender = Rpc_V1_AccountAddress.with {
            $0.address = sourceWallet.address
        }

        let _destination = Rpc_V1_AccountAddress.with {
            $0.address = destinationAddress
        }

        let transaction = Rpc_V1_Transaction.with {
            $0.account = _sender
            $0.fee = fee.drops.baseFee
            $0.sequence = UInt32(lastValidatedLedgerSequence)
            $0.payment = Rpc_V1_Payment.with {
                $0.destination = _destination
                $0.amount = xrpAmount
            }

            // Format For Hex
            $0.signingPublicKey = sourceWallet.publicKey.data(using: .ascii)!
            $0.lastLedgerSequence = lastValidatedLedgerSequence + ledgerSequenceMargin
        }

        guard let signedTransactionData = Signer.sign(transaction, with: sourceWallet) else {
            throw XRPLedgerError.signingError
        }

        let submitTransactionRequest = Rpc_V1_SubmitTransactionRequest.with {
            $0.signedTransaction = signedTransactionData.signature
        }

        let submitTransactionResponse = try networkClient.submitTransaction(submitTransactionRequest)
        guard let hash = Utils.toTransactionHash(transactionBlobHex: submitTransactionResponse.hash.base64EncodedString()) else {
            throw XRPLedgerError.unknown("Could not hash transaction blob: \(submitTransactionResponse.hash)")
        }

//        throw XRPLedgerError.unimplemented("This Function is not implemented yet... See Keefer & Denis")

        return hash
    }

    /// Retrieve the latest validated ledger sequence on the XRP Ledger.
    ///
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The index of the latest validated ledger.
    public func getLatestValidatedLedgerSequence() throws -> UInt32 {
        let fee = try getFee()
        return UInt32(fee.ledgerCurrentIndex)
    }

    /// Retrieve the raw transaction status for the given transaction hash.
    ///
    /// - Parameter transactionHash: The hash of the transaction.
    /// - Throws: An error if there was a problem communicating with the XRP Ledger.
    /// - Returns: The status of the given transaction.
    public func getRawTx(for transactionHash: TransactionHash) throws -> Rpc_V1_GetTxResponse {
        let transactionRequest = Rpc_V1_GetTxRequest.with { $0.hash = Data(Utils.toByteArray(hex: transactionHash)) }
        return try networkClient.getTx(transactionRequest)
    }
}
