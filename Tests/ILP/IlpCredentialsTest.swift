import XCTest
@testable import XpringKit
class IlpCredentialsTest: XCTestCase {

  func testConstructIlpCredentialsWithoutPrefix() throws {
    // GIVEN a bearer token with no "Bearer " prefix
    let bearerToken: String = .testAccessToken

    // WHEN IlpCredentials are initialized
    let credentials = try IlpCredentials(bearerToken)

    // THEN the credentials' Metadata has an Authorization header
    // AND "Bearer " prefix has been prepended to bearerToken
    XCTAssertEqual(
      credentials.getMetadata().dictionaryRepresentation["authorization"],
      "Bearer " + .testAccessToken
    )
  }

  func testConstructIlpCredentialsWithPrefix() throws {
    // GIVEN a bearer token with a "Bearer " prefix
    let bearerToken: String = "Bearer " + .testAccessToken

    // WHEN IlpCredentials are initialized
    // THEN an Error is thrown
    XCTAssertThrowsError(
      try IlpCredentials(bearerToken),
      IlpError.invalidAccessToken.localizedDescription
    )
  }
}
