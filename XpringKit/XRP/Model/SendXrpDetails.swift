/// Describes the fine grained details for sending XRP. The destination field may be a PayID, XAddress,
/// or other type of address. Handling of the given destination type is the responsibility of the client.
public struct SendXrpDetails {
  
  /// The amount of XRP, in drops, to send.
  public let amount: UInt64

  /// The recieving address.
  public let destination: Address
  
  /// The sending wallet.
  public let sender: Wallet
  
  /// A list of memos to attach to this payment transaction.
  public let memosList: Array<XRPMemo>
}
