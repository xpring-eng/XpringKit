import BigInt
import XCTest
@testable import XpringKit

final class DefaultXpringClientTest: XCTestCase {

  // MARK: - Balance

  func testGetBalance() {
    // GIVEN a XpringClient.
    let xpringClient = DefaultXpringClient()

    // WHEN the balance is retrieved THEN an error is thrown.
    XCTAssertThrowsError(try xpringClient.getBalance(for: .testAddress))
  }
}
