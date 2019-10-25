import XCTest
import XpringKit

class UtilsTest: XCTestCase {

  // MARK: - isValid

	func testIsValidAddressValidClassicAddress() {
    XCTAssertTrue(Utils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
	}

  func testIsValidAddressValidXAddress() {
    XCTAssertTrue(Utils.isValid(address: "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHi"))
  }

	func testIsValidAddressInvalidAlphabet() {
    XCTAssertFalse(Utils.isValid(address: "1EAG1MwmzkG6gRZcYqcRMfC17eMt8TDTit"))
	}

	func testIsvValidAddressInvalidChecksumClassicAddress() {
    XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4sBBBBBaU29sesqs2qTQJWDw1"))
	}

  func testIsvValidAddressInvalidChecksumXAddress() {
    XCTAssertFalse(Utils.isValid(address: "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHI"))
  }

	func testIsValidAddressInvalidCharacters() {
    XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4sBBBBBaU@#$%qs2qTQJWDw1"))
	}

	func testIsValidAddressTooLong() {
    XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"))
	}

	func testIsValidAddressTooShort() {
    XCTAssertFalse(Utils.isValid(address: "rU6K7V3Po4s2qTQJWDw1"))
	}

  // MARK: - isValidXAddress

  func testIsValidXAddressWithXAddress() {
    // GIVEN a valid X-Address.
    let address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUvtU3HnooQDgBnUpQT"

    // WHEN the address is validated for being an X-Address.
    let isValid = Utils.isValidXAddress(address: address)

    // THEN the address is reported as valid.
    XCTAssertTrue(isValid)
  }

  func testIsValidXAddressWithClassicAddress() {
    // GIVEN a valid classic address.
    let address = "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"

    // WHEN the address is validated for being an X-Address.
    let isValid = Utils.isValidXAddress(address: address)

    // THEN the address is reported as invalid.
    XCTAssertFalse(isValid)
  }

  func testIsValidXAddressWithInvalidAddress() {
    // GIVEN an invalid address.
    let address = "xrp"

    // WHEN the address is validated for being an X-Address.
    let isValid = Utils.isValidXAddress(address: address)

    // THEN the address is reported as invalid.
    XCTAssertFalse(isValid)
  }

  // MARK: - isValidClassicAddress

  func testIsValidClassicAddressWithXAddress() {
    // GIVEN a valid X-Address.
    let address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUvtU3HnooQDgBnUpQT"

    // WHEN the address is validated for being a classic address.
    let isValid = Utils.isValidClassicAddress(address: address)

    // THEN the address is reported as valid.
    XCTAssertFalse(isValid)
  }

  func testIsValidClassicAddressWithClassicAddress() {
    // GIVEN a valid classic address.
    let address = "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"

    // WHEN the address is validated for being a classic address.
    let isValid = Utils.isValidClassicAddress(address: address)

    // THEN the address is reported as invalid.
    XCTAssertTrue(isValid)
  }

  func testIsValidClassicAddressWithInvalidAddress() {
    // GIVEN an invalid address.
    let address = "xrp"

    // WHEN the address is validated for being a classic address.
    let isValid = Utils.isValidClassicAddress(address: address)

    // THEN the address is reported as invalid.
    XCTAssertFalse(isValid)
  }

  // MARK: - encode

  func testEncodeXAddressWithAddressAndTag() {
    // GIVEN a valid classic address and a tag.
    let address =  "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"
    let tag: UInt32 = 12_345

    // WHEN they are encoded to an x-address.
    let xAddress = Utils.encode(classicAddress: address, tag: tag)

    // THEN the result is as expected.
    XCTAssertEqual(xAddress, "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUvtU3HnooQDgBnUpQT")
  }

  func testEncodeXAddressWithAddressOnly() {
    // GIVEN a valid classic address.
    let address = "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"

    // WHEN it is encoded to an x-address.
    let xAddress = Utils.encode(classicAddress: address)

    // THEN the result is as expected.
    XCTAssertEqual(xAddress, "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH")
  }

  func testEncodeXAddressWithInvalidAddress() {
    // GIVEN an invalid address.
    let address = "xrp"

    // WHEN it is encoded to an x-address.
    let xAddress = Utils.encode(classicAddress: address)

    // THEN the result is undefined.
    XCTAssertNil(xAddress)
  }

  // MARK: - decode

  func testDecodeXAddressWithAddressAndTag() {
    // GIVEN an x-address that encodes an address and a tag.
    let address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUvtU3HnooQDgBnUpQT"

    // WHEN it is decoded to an classic address
    guard let classicAddressTuple = Utils.decode(xAddress: address) else {
      XCTFail("Failed to decode a valid X-Address")
      return
    }

    // THEN the decoded address and tag as are expected.
    XCTAssertEqual(classicAddressTuple.classicAddress, "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1")
    XCTAssertEqual(classicAddressTuple.tag, 12_345)
  }

  func testDecodeXAddressWithAddressOnly() {
    // GIVEN an x-address that encodes an address and no tag.
    let address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUFyQVMzRrMGUZpokKH"

    // WHEN it is decoded to an classic address
    guard let classicAddressTuple = Utils.decode(xAddress: address) else {
      XCTFail("Failed to decode a valid X-Address")
      return
    }

    // THEN the decoded address and tag as are expected.
    XCTAssertEqual(classicAddressTuple.classicAddress, "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1")
    XCTAssertNil(classicAddressTuple.tag)
  }

  func testDecodXAddresWithInvalidAddress() {
    // GIVEN an invalid address
    let address = "xrp"

    // WHEN it is decoded to an classic address
    let classicAddressTuple = Utils.decode(xAddress: address)

    // THEN the decoded address is undefined.
    XCTAssertNil(classicAddressTuple)
  }
}
