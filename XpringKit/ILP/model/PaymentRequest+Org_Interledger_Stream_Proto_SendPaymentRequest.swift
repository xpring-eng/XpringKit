/// Conforms to PaymentRequest struct and provides a converter to Org_Interledger_Stream_Proto_SendPaymentRequest
extension PaymentRequest {
    
    /// Initializes a PaymentRequest with more idiomatic parameter labels
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
