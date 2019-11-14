import BigInt

public class XpringClient: XpringClientDecorator {
  private let decoratedClient: XpringClientDecorator

  public init(grpcURL: String) {
    decoratedClient = DefaultXpringClient(grpcURL: grpcURL)
  }

  public func getBalance(for address: Address) throws -> BigUInt {
    return try decoratedClient.getBalance(for: address)
  }

  public func send(_ amount: BigUInt, to destinationAddress: Address, from sourceWallet: Wallet) throws -> TransactionHash {
    return try decoratedClient.send(amount, to: destinationAddress, from: sourceWallet)
  }
}
