/// A response object containing details about a requested payment
public struct PaymentResult {
    
     /// A UInt64 representing the original amount to be sent in a given payment.
    public let originalAmount: UInt64
    
    
    /// The actual amount, in the receivers units, that was delivered to the receiver. Any currency conversion and/or
    /// connector fees may cause this to be different than the amount sent.
    public let amountDelivered: UInt64
    
    
    /// The actual amount, in the senders units, that was sent to the receiver. In the case of a timeout or rejected
    /// packets this amount may be less than the requested amount to be sent.
    public let amountSent: UInt64
    
    
    /// Indicates if the payment was completed successfully.
    /// true if payment was successful
    public let successfulPayment: Bool
    
    
    /// Constructs a PaymentResult from a protobuf SendPaymentResponse
    ///
    /// - Parameters:
    ///     - protoResponse: a SendPaymentResponse to be converted
    /// - Returns: a PaymentResult with fields populated using the analogous fields in the proto object
    public static func from(
        _ sendPaymentResponse: Org_Interledger_Stream_Proto_SendPaymentResponse
    ) -> PaymentResult {
        return PaymentResult(
            originalAmount: sendPaymentResponse.originalAmount,
            amountDelivered: sendPaymentResponse.amountDelivered,
            amountSent: sendPaymentResponse.amountSent,
            successfulPayment: sendPaymentResponse.successfulPayment
        )
    }
}
