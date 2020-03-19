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
}
