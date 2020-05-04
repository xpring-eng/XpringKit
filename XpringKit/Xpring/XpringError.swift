/// Errors that may occur when interacting with Xpring components.
public enum XpringError: Equatable, Error {
  /// Input entities given to a Xpring component were attached to different networks.
  ///
  /// For instance, this error may be thrown if a XpringClient was constructed with a PayIDClient attached to Testnet
  /// and an XRPClient attached to Mainnet.
  case mismatchedNetworks
}
