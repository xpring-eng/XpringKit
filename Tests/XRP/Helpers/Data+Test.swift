import Foundation

extension Data {
  public static let testPublicKey = Data([1, 2, 3])
  public static let testTransactionSignature = Data([4, 5, 6])
  public static let testHash = Data([2, 4, 6])
  public static let testEmailHashValue = Data([8, 9, 10])
  public static let testMessageKeyValue = Data([11, 12, 13])
  public static let testCheckIdValue = Data(base64Encoded: "49647F0D748DC3FE26BDACBC57F251AADEFFF391403EC9BF87C97F67E9977FB0")!
}
