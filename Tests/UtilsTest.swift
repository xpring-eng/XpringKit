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

  func testIsValidAddressInvalidChecksumClassicAddress() {
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

  func testEncodeMainNetXAddressWithAddressAndTag() {
    // GIVEN a valid classic address and a tag.
    let address =  "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"
    let tag: UInt32 = 12_345

    // WHEN they are encoded to an X-Address on MainNet.
    let xAddress = Utils.encode(classicAddress: address, tag: tag)

    // THEN the result is as expected.
    XCTAssertEqual(xAddress, "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUvtU3HnooQDgBnUpQT")
  }

  func testEncodeTestNetXAddressWithAddressAndTag() {
    // GIVEN a valid classic address and a tag.
    let address =  "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"
    let tag: UInt32 = 12_345

    // WHEN they are encoded to an X-Address on MainNet.
    let xAddress = Utils.encode(classicAddress: address, tag: tag, isTest: true)

    // THEN the result is as expected.
    XCTAssertEqual(xAddress, "TVsBZmcewpEHgajPi1jApLeYnHPJw82v9JNYf7dkGmWphmh")
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

  func testDecodeMainNetXAddressWithAddressAndTag() {
    // GIVEN an X-Address on MainNet that encodes an address and a tag.
    let address = "XVfC9CTCJh6GN2x8bnrw3LtdbqiVCUvtU3HnooQDgBnUpQT"

    // WHEN it is decoded to an classic address
    guard let classicAddressTuple = Utils.decode(xAddress: address) else {
      XCTFail("Failed to decode a valid X-Address")
      return
    }

    // THEN the decoded address and tag as are expected.
    XCTAssertEqual(classicAddressTuple.classicAddress, "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1")
    XCTAssertEqual(classicAddressTuple.tag, 12_345)
    XCTAssertFalse(classicAddressTuple.isTest)
  }

  func testDecodeTestNetXAddressWithAddressAndTag() {
    // GIVEN an X-Address on Testnet that encodes an address and a tag.
    let address = "TVsBZmcewpEHgajPi1jApLeYnHPJw82v9JNYf7dkGmWphmh"

    // WHEN it is decoded to an classic address
    guard let classicAddressTuple = Utils.decode(xAddress: address) else {
      XCTFail("Failed to decode a valid X-Address")
      return
    }

    // THEN the decoded address and tag as are expected.
    XCTAssertEqual(classicAddressTuple.classicAddress, "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1")
    XCTAssertEqual(classicAddressTuple.tag, 12_345)
    XCTAssertTrue(classicAddressTuple.isTest)
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

  // MARK: - toTransactionHash

  func testToTransactionHashValidTransaction() {
    // GIVEN a transaction blob.
    // swiftlint:disable line_length
    let transactionBlobHex = "120000240000000561400000000000000168400000000000000C73210261BBB9D242440BA38375DAD79B146E559A9DFB99055F7077DA63AE0D643CA0E174473045022100C8BB1CE19DFB1E57CDD60947C5D7F1ACD10851B0F066C28DBAA3592475BC3808022056EEB85CC8CD41F1F1CF635C244943AD43E3CF0CE1E3B7359354AC8A62CF3F488114F8942487EDB0E4FD86190BF8DCB3AF36F608839D83141D10E382F805CD7033CC4582D2458922F0D0ACA6"
    // swiftlint:enable line_length

    // WHEN the transaction blob is converted to a hash.
    let transactionHash = Utils.toTransactionHash(transactionBlobHex: transactionBlobHex)

    // THEN the transaction blob is as expected.
    XCTAssertEqual(
      transactionHash,
      "7B9F6E019C2A79857427B4EF968D77D683AC84F5A880830955D7BDF47F120667"
    )
  }

  func testToTransactionHashInvalidTransaction() {
    // GIVEN an invalid transaction blob.
    let transactionBlobHex = "xrp"

    // WHEN the transaction blob is converted to a hash.
    let transactionHash = Utils.toTransactionHash(transactionBlobHex: transactionBlobHex)

    // THEN the hash is nil.
    XCTAssertNil(transactionHash)
  }

  // MARK: - dropsToXrp

  func testDropsToXrpWorksWithTypicalAmount() throws {
    // GIVEN a typical, valid drops value, WHEN converted to xrp
    let xrp: String = try Utils.dropsToXrp("2000000")

    // THEN the conversion is as expected
    XCTAssertEqual("2", xrp, "2 million drops equals 2 XRP")
  }

  func testDropsToXrpWorksWithFractions() throws {
    // GIVEN drops amounts that convert to fractional xrp amounts
    // WHEN converted to xrp THEN the conversion is as expected
    var xrp: String = try Utils.dropsToXrp("3456789")
    XCTAssertEqual("3.456789", xrp, "3,456,789 drops equals 3.456789 XRP")

    xrp = try Utils.dropsToXrp("3400000")
    XCTAssertEqual("3.4", xrp, "3,400,000 drops equals 3.4 XRP")

    xrp = try Utils.dropsToXrp("1")
    XCTAssertEqual("0.000001", xrp, "1 drop equals 0.000001 XRP")

    xrp = try Utils.dropsToXrp("1.0")
    XCTAssertEqual("0.000001", xrp, "1.0 drops equals 0.000001 XRP")

    xrp = try Utils.dropsToXrp("1.00")
    XCTAssertEqual("0.000001", xrp, "1.00 drops equals 0.000001 XRP")
  }

  func testDropsToXrpWorksWithZero() throws {
    // GIVEN several equivalent representations of zero
    // WHEN converted to xrp, THEN the result is zero
    var xrp: String = try Utils.dropsToXrp("0")
    XCTAssertEqual("0", xrp, "0 drops equals 0 XRP")

    // negative zero is equivalent to zero
    xrp = try Utils.dropsToXrp("-0")
    XCTAssertEqual("0", xrp, "-0 drops equals 0 XRP")

    xrp = try Utils.dropsToXrp("0.00")
    XCTAssertEqual("0", xrp, "0.00 drops equals 0 XRP")

    xrp = try Utils.dropsToXrp("000000000")
    XCTAssertEqual("0", xrp, "000000000 drops equals 0 XRP")
  }

  func testDropsToXrpWorksWithNegativeValues() throws {
    // GIVEN a negative drops amount
    // WHEN converted to xrp
    let xrp: String = try Utils.dropsToXrp("-2000000")

    // THEN the conversion is also negative
    XCTAssertEqual("-2", xrp, "-2 million drops equals -2 XRP")
  }

  func testDropsToXrpWorksWithValueEndingWithDecimalPoint() throws {
    // GIVEN a positive or negative drops amount that ends with a decimal point
    // WHEN converted to xrp THEN the conversion is successful and correct
    var xrp: String = try Utils.dropsToXrp("2000000.")
    XCTAssertEqual("2", xrp, "2000000. drops equals 2 XRP")

    xrp = try Utils.dropsToXrp("-2000000.")
    XCTAssertEqual("-2", xrp, "-2000000. drops equals -2 XRP")
  }

  func testDropsToXrpThrowsWithAnAmountWithTooManyDecimalPlaces() {
    XCTAssertThrowsError(try Utils.dropsToXrp("1.2"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.dropsToXrp("0.10"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
  }

  func testDropsToXrpThrowsWithAnInvalidValue() {
    // GIVEN invalid drops values, WHEN converted to xrp, THEN an exception is thrown
    XCTAssertThrowsError(try Utils.dropsToXrp("FOO"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.dropsToXrp("1e-7"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.dropsToXrp("2,0"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.dropsToXrp("."), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
  }

  func testDropsToXrpThrowsWithAnAmountMoreThanOneDecimalPoint() {
    // GIVEN invalid drops values that contain more than one decimal point
    // WHEN converted to xrp THEN an exception is thrown
    XCTAssertThrowsError(try Utils.dropsToXrp("1.0.0"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.dropsToXrp("..."), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
  }

  func testDropsToXrpThrowsWithNullArgument() {
    // GIVEN a nil drops value, WHEN converted to XRP,
    // THEN an exception is thrown
    // TODO: do we need this test case?
  }

  // MARK: - xrpToDrops

  func testXrpToDropsWorksWithATypicalAmount() throws {
    // GIVEN an xrp amount that is typical and valid
    // WHEN converted to drops
    let drops: String = try Utils.xrpToDrops("2")

    // THEN the conversion is successful and correct
    XCTAssertEqual("2000000", drops, "2 XRP equals 2 million drops")
  }

  func testXrpToDropsWorksWithFractions() throws {
    // GIVEN xrp amounts that are fractional
    // WHEN converted to drops THEN the conversions are successful and correct
    var drops: String = try Utils.xrpToDrops("3.456789")
    XCTAssertEqual("3456789", drops, "3.456789 XRP equals 3,456,789 drops")
    drops = try Utils.xrpToDrops("3.400000")
    XCTAssertEqual("3400000", drops, "3.400000 XRP equals 3,400,000 drops")
    drops = try Utils.xrpToDrops("0.000001")
    XCTAssertEqual("1", drops, "0.000001 XRP equals 1 drop")
    drops = try Utils.xrpToDrops("0.0000010")
    XCTAssertEqual("1", drops, "0.0000010 XRP equals 1 drop")
  }

  func testXrpToDropsWorksWithZero() throws {
    // GIVEN xrp amounts that are various equivalent representations of zero
    // WHEN converted to drops THEN the conversions are equal to zero
    var drops: String = try Utils.xrpToDrops("0")
    XCTAssertEqual("0", drops, "0 XRP equals 0 drops")
    drops = try Utils.xrpToDrops("-0"); // negative zero is equivalent to zero
    XCTAssertEqual("0", drops, "-0 XRP equals 0 drops")
    drops = try Utils.xrpToDrops("0.000000")
    XCTAssertEqual("0", drops, "0.000000 XRP equals 0 drops")
    drops = try Utils.xrpToDrops("0.0000000")
    XCTAssertEqual("0", drops, "0.0000000 XRP equals 0 drops")
  }

  func testXrpToDropsWorksWithNegativeValues() throws {
    // GIVEN a negative xrp amount
    // WHEN converted to drops THEN the conversion is also negative
    let drops: String = try Utils.xrpToDrops("-2")
    XCTAssertEqual("-2000000", drops, "-2 XRP equals -2 million drops")
  }

  func testXrpToDropsWorksWithAValueEndingWithADecimalPoint() throws {
    // GIVEN an xrp amount that ends with a decimal point
    // WHEN converted to drops THEN the conversion is correct and successful
    var drops: String = try Utils.xrpToDrops("2.")
    XCTAssertEqual("2000000", drops, "2. XRP equals 2000000 drops")
    drops = try Utils.xrpToDrops("-2.")
    XCTAssertEqual("-2000000", drops, "-2. XRP equals -2000000 drops")
  }

  func testXrpToDropsThrowsWithAnAmountWithTooManyDecimalPlaces() {
    // GIVEN an xrp amount with too many decimal places
    // WHEN converted to a drops amount THEN an exception is thrown
    XCTAssertThrowsError(try Utils.xrpToDrops("1.1234567"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.xrpToDrops("0.0000001"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
  }

  func testXrpToDropsThrowsWithAnInvalidValue() {
    // GIVEN xrp amounts represented as various invalid values
    // WHEN converted to drops THEN an exception is thrown
    XCTAssertThrowsError(try Utils.xrpToDrops("FOO"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.xrpToDrops("1e-7"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.xrpToDrops("2,0"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.xrpToDrops("."), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
  }

  func testXrpToDropsThrowsWithAnAmountMoreThanOneDecimalPoint() {
    // GIVEN an xrp amount with more than one decimal point, or all decimal points
    // WHEN converted to drops THEN an exception is thrown
    XCTAssertThrowsError(try Utils.xrpToDrops("1.0.0"), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
    XCTAssertThrowsError(try Utils.xrpToDrops("..."), "Exception not thrown") { error in
      guard
        error as? XRPLedgerError != nil
        else {
          XCTFail("Error thrown was not XRPLedgerError")
          return
      }
    }
  }

  func testXrpToDropsThrowsWithNullArgument() {
    // GIVEN a nil xrp value, WHEN converted to drops,
    // THEN an exception is thrown
    // TODO: do we need this test case?
  }
}
