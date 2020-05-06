import XCTest
@testable import XpringKit

final class XRPPayIDClientTest: XCTestCase {
  func testToXAddressWithXAddress() throws {
    // GIVEN an XRPPayIDClient, and a CryptoAddressDetails that already contains an X-Address.
    let payIDClient = XRPPayIDClient(xrplNetwork: .test)
    let xAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
    let cryptoAddressDetails = CryptoAddressDetails(address: xAddress, tag: nil)

    // WHEN the X-Address is converted to an X-Address.
    let encodedAddress = try payIDClient.toXAddress(cryptoAddressDetails: cryptoAddressDetails)

    // THEN the address is returned unchanged.
    XCTAssertEqual(encodedAddress, xAddress)

  }

  func testToXAddressWithClassicAddressNoTag() throws {
    // GIVEN an XRPPayIDClient, and a CryptoAddressDetails that contains a classic address and no tag.
    let payIDClient = XRPPayIDClient(xrplNetwork: .test)
    let address = "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY"
    let cryptoAddressDetails = CryptoAddressDetails(address: address, tag: nil)

    let expectedXAddress = Utils.encode(classicAddress: address, tag: nil, isTest: true)

    // WHEN the classic address is converted to an X-Address.
    let encodedAddress = try payIDClient.toXAddress(cryptoAddressDetails: cryptoAddressDetails)

    // THEN the address is returned unchanged.
    XCTAssertEqual(encodedAddress, expectedXAddress)
  }

  func testToXAddressWithClassicAddressAndTag() throws {
    // GIVEN an XRPPayIDClient, and a CryptoAddressDetails that contains a classic address and a tag.
    let payIDClient = XRPPayIDClient(xrplNetwork: .test)
    let address = "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY"
    let tag = 12_345
    let cryptoAddressDetails = CryptoAddressDetails(address: address, tag: String(tag))

    let expectedXAddress = Utils.encode(classicAddress: address, tag: UInt32(tag), isTest: true)

    // WHEN the classic address is converted to an X-Address.
    let encodedAddress = try payIDClient.toXAddress(cryptoAddressDetails: cryptoAddressDetails)

    // THEN the address is returned unchanged.
    XCTAssertEqual(encodedAddress, expectedXAddress)

  }
}
