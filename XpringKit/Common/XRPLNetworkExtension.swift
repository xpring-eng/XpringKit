import Foundation

extension XRPLNetwork {
  public var isTest: Bool {
    return self != .main
  }
}
