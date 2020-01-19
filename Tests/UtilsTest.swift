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
        let transactionBlobHex = "120000240000000561400000000000000168400000000000000C73210261BBB9D242440BA38375DAD79B146E559A9DFB99055F7077DA63AE0D643CA0E174473045022100C8BB1CE19DFB1E57CDD60947C5D7F1ACD10851B0F066C28DBAA3592475BC3808022056EEB85CC8CD41F1F1CF635C244943AD43E3CF0CE1E3B7359354AC8A62CF3F488114F8942487EDB0E4FD86190BF8DCB3AF36F608839D83141D10E382F805CD7033CC4582D2458922F0D0ACA6"

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

    // MARK: - toBytesArray

    func testToBytesArrayValidTransactionHash() {
        // GIVEN a transaction hex.
        let hex = "9A88C8548E03958FD97AF44AE5A8668896D195A70CF3FF3CB8E57096AA717135"

        let hexBytesArray = Utils.toByteArray(hex: hex)

        // THEN the transaction hex toHex is as expected.
        XCTAssertEqual(
            hexBytesArray,
            [154, 136, 200, 84, 142, 3, 149, 143, 217, 122, 244, 74, 229, 168, 102, 136, 150, 209, 149, 167, 12, 243, 255, 60, 184, 229, 112, 150, 170, 113, 113, 53]
        )
    }

    func testToBytesArrayEmptyTransactionHash() {
        // GIVEN an invalid hex.
        let hex = ""
        let hexBytesArray = Utils.toByteArray(hex: hex)

        // THEN the transaction hex toHex is as expected.
        XCTAssertEqual(
            hexBytesArray,
            []
        )
    }
}
