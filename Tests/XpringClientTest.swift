import XCTest
@testable import XpringKit

extension Wallet {
  public static let testWallet = Wallet(seed: "saNTy6oyVyMhCScBdKUNg2tFWwPKa")!
}

final class XpringClientTest: XCTestCase {
  let xrpClient = XpringClient(grpcURL: .grpcURL)

  func testClassicAddressSend() {
    // An address to receive XRP.
    let recipientAddress = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"

    let result = try! xrpClient.send(.oneDrop, to: recipientAddress, from: .testWallet)

    print("Sent to a classic address with result: \(result.engineResultMessage)")
  }

  func testClassicAddressWithTag() {
    // An address and tag to receive XRP.
    let recipientAddress = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
    let recipientTag: UInt32 = 123

    let result = try! xrpClient.send(.twoDrops, to: recipientAddress, destinationTag: recipientTag, from: .testWallet)
    print("Sent to a classic address and a tag with result: \(result.engineResultMessage)")
  }

  func testXAddress() {
    // An X-Address that's going to get some XRP
    let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfTSaLz88QUHWjDGoao"
    let result = try! xrpClient.send(.threeDrops, to: recipientAddress, from: .testWallet)
    print("Sent to a classic address with result: \(result.engineResultMessage)")
  }

  func testSendWithEncodeXAddress() {
    // Some classic address inputs
    let recipientAddress = "rsegqrgSP8XmhCYwL9enkZ9BNDNawfPZnn"
    let recipientTag: UInt32 = 123

    // Make an X-Address!
    let xAddress = Utils.encode(classicAddress: recipientAddress, tag: recipientTag)!
    print("Derived the corresponding X-Address as: \(xAddress)")

    // Send to that address
    let result = try! xrpClient.send(.fourDrops, to: xAddress, from: .testWallet)
    print("Sent to a derived X-Address result: \(result.engineResultMessage)")
  }

  override func setUp() {
    print("\n\n")
  }

  override func tearDown() {
    print("\n\n")
  }
}

extension Io_Xpring_XRPAmount {
  public static let oneDrop = Io_Xpring_XRPAmount.with { $0.drops = "1" }
  public static let twoDrops = Io_Xpring_XRPAmount.with { $0.drops = "2" }
  public static let threeDrops = Io_Xpring_XRPAmount.with { $0.drops = "3" }
  public static let fourDrops = Io_Xpring_XRPAmount.with { $0.drops = "4" }
}

extension String {
  public static let grpcURL = "grpc.xpring.tech:80"
}
