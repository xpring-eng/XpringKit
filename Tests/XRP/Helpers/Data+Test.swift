import Foundation

extension Data {
  public static let testPublicKey = Data([1, 2, 3])
  public static let testTransactionSignature = Data([4, 5, 6])
  public static let testHash = Data([2, 4, 6])
  public static let testEmailHashValue = Data([8, 9, 10])
  public static let testMessageKeyValue = Data([11, 12, 13])
  public static let testCheckIdValue = "49647F0D748DC3FE26BDACBC57F251AADEFFF391403EC9BF87C97F67E9977FB0".data(
    using: .utf8
  )!
  public static let testInvoiceIdValue = "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B".data(
    using: .utf8
  )!
  public static let testConditionValue = "condition".data(using: .utf8)!
  public static let testFulfillmentValue = "A0028000".data(using: .utf8)!
  public static let testChannelValue = "C1AE6DDDEEC05CF2978C0BAD6FE302948E9533691DC749DCDD3B9E5992CA6198".data(
    using: .utf8
    )!
  public static let testPaymentChannelSignature =
    """
    30440220718D264EF05CAED7C781FF6DE298DCAC68D002562C9BF3A07C1E721B420C0DAB02203A5A779EF4
    D2CCC7BC3EF886676D803A9981B928D3B8ACA483B80ECA3CD7B9B
    """.data(using: .utf8)!
  public static let testPaymentChannelPublicKey =
    "32D2471DB72B27E3310F355BB33E339BF26F8392D5A93D3BC0FC3B566612DA0F0A"
      .data(using: .utf8)!
}
