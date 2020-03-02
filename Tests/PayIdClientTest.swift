import XCTest
import XpringKit

let fakeRemoteURL = URL(string: "payid.xpring.io")!
let fakeAuthorizationToken = "abc123"

final class PayIDTests: XCTestCase {
  func testIsAuthorizedWithAuthorizedClient() {
    // GIVEN an authorized payID client.
    let payIDClient = PayIDClient(remoteURL: fakeRemoteURL, authorizationToken: fakeAuthorizationToken)

    // WHEN the client is asked if it is authorized to update pointers.
    let isAuthorized = payIDClient.isAuthorizedForUpdates

    // THEN the client reports that it is authorized.
    XCTAssertTrue(isAuthorized)
  }

  func testIsAuthorizedWithUnAuthorizedClient() {
    // GIVEN an unauthorized payID client.
    let payIDClient = PayIDClient(remoteURL: fakeRemoteURL)

    // WHEN the client is asked if it is authorized to update pointers.
    let isAuthorized = payIDClient.isAuthorizedForUpdates

    // THEN the client reports that it is unauthorized.
    XCTAssertFalse(isAuthorized)
  }

    // TODO(keefertaylor): Add additional tests for PayID client when functionality is implemented.
}
