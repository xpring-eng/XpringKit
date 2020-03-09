internal extension XRPPath {
  init(path: Org_Xrpl_Rpc_V1_Payment.Path) {
    self.pathElements = path.elements.map { pathElement in XRPPathElement(pathElement: pathElement) }
  }
}
