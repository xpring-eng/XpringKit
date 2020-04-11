/// A path in the XRP Ledger.
/// - SeeAlso: https://xrpl.org/paths.html
public struct XRPPath: Equatable {
  
  /// List of XRPPathElements that make up this XRPPath.
  public let pathElements: [XRPPathElement]
}
