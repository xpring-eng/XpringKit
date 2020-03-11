/// A request object that can be used to send a payment request to a connector
public struct PaymentRequest {

    /// The amount to send.  This amount is denominated in the asset code and asset scale of the sender's account
    /// on the connector.  For example, if the account has an asset code of "USD" and an asset scale of 9,
    /// a payment request of 100 units would send 100 nano-dollars.
    public let amount: UInt64

    /// A payment pointer is a standardized identifier for payment accounts.
    /// This payment pointer will be the identifier for the account of the recipient of this payment on the ILP
    /// network.
    ///
    /// See "https://github.com/interledger/rfcs/blob/master/0026-payment-pointers/0026-payment-pointers.md"
    public let destinationPaymentPointer: PaymentPointer

    /// The accountID of the sender.
    public let senderAccountID: AccountID

    public init(
        _ amount: UInt64,
        to destinationPaymentPointer: PaymentPointer,
        from senderAccountID: AccountID
    ) {
        self.amount = amount
        self.destinationPaymentPointer = destinationPaymentPointer
        self.senderAccountID = senderAccountID
    }

    /// Constructs a SendPaymentRequest from this PaymentRequest (non-proto)
    ///
    /// - Returns: A SendPaymentRequest populated with the analogous fields in a PaymentRequest
    public func toProto() -> Org_Interledger_Stream_Proto_SendPaymentRequest {
        return Org_Interledger_Stream_Proto_SendPaymentRequest.with {
            $0.amount = self.amount
            $0.destinationPaymentPointer = self.destinationPaymentPointer
            $0.accountID = self.senderAccountID
        }
    }
}
