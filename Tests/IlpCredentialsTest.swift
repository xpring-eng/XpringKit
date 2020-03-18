import XCTest
@testable import XpringKit
class IlpCredentialsTest: XCTestCase {

    func testConstructIlpCredentialsWithoutPrefix() throws {
        // GIVEN a bearer token with no "Bearer " prefix
        let bearerToken: String = .testBearerToken

        // WHEN IlpCredentials are initialized
        let credentials = try IlpCredentials(bearerToken)

        // THEN the credentials' Metadata has an Authorization header
        // AND "Bearer " prefix has been prepended to bearerToken
        XCTAssertEqual(
            credentials.get().dictionaryRepresentation["authorization"],
            "Bearer " + .testBearerToken
        )
    }

    func testConstructIlpCredentialsWithPrefix() throws {
        // GIVEN a bearer token with a "Bearer " prefix
        let bearerToken: String = "Bearer " + .testBearerToken

        // WHEN IlpCredentials are initialized
        let credentials = try IlpCredentials(bearerToken)

        // THEN the credentials' Metadata has an Authorization header
        // AND its value is equal to bearerToken
        XCTAssertEqual(
            credentials.get().dictionaryRepresentation["authorization"],
            bearerToken
        )
    }
}
