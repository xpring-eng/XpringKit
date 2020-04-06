/// Conforms to PaymentResult struct while providing an initializer that can construct a PaymentResult from an
/// Org_Interledger_Stream_Proto_SendPaymentResponse
extension PaymentResult {

  /// Constructs a PaymentResult from a protobuf SendPaymentResponse
  ///
  /// - Parameters:
  ///     - protoResponse: a SendPaymentResponse to be converted
  /// - Returns: a PaymentResult with fields populated using the analogous fields in the proto object
  public init(sendPaymentResponse: Org_Interledger_Stream_Proto_SendPaymentResponse) {
    self.init(
      originalAmount: sendPaymentResponse.originalAmount,
      amountDelivered: sendPaymentResponse.amountDelivered,
      amountSent: sendPaymentResponse.amountSent,
      successfulPayment: sendPaymentResponse.successfulPayment
    )
  }
}
