import SwiftGRPC
import XpringKit

/// A fake payment network client which fakes calls.
public class FakeIlpPaymentNetworkClient {
  /// Result of a call to sendPayment
  private let sendPaymentResult: Result<Org_Interledger_Stream_Proto_SendPaymentResponse, Error>

  /// Initialize a new FakeIlpPaymentNetworkClient
  ///
  /// - Parameters:
  ///     - sendPaymentResult: A result which will be used to determine the behavior of sendPayment()
  public init(sendPaymentResult: Result<Org_Interledger_Stream_Proto_SendPaymentResponse, Error>) {
    self.sendPaymentResult = sendPaymentResult
  }
}

/// Conform to IlpPaymentNetworkClient protocol, returning faked results
extension FakeIlpPaymentNetworkClient: IlpNetworkPaymentClient {
  public func sendMoney(
    _ request: Org_Interledger_Stream_Proto_SendPaymentRequest,
    metadata customMetadata: Metadata
  ) throws -> Org_Interledger_Stream_Proto_SendPaymentResponse {
    switch sendPaymentResult {
    case .success(let payment):
      return payment
    case .failure(let error):
      throw error
    }
  }
}
