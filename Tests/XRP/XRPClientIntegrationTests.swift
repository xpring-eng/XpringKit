import XCTest
@testable import XpringKit

extension String {
  /// The URL of a remote rippled node with gRPC enabled.
  public static let remoteURL = "test.xrp.xpring.io:50051"

  /// An address on the chain to receive funds.
  public static let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
}

/// Integration tests run against a live remote client.
final class XRPClientIntegrationTests: XCTestCase {
  private let client = XRPClient(grpcURL: .remoteURL, network: .test)

  private let wallet = try! Wallet.randomWalletFromFaucet()

  // MARK: - rippled Protocol Buffers

  func testGetBalance() {
    do {
      _ = try client.getBalance(for: wallet.address)
    } catch {
      XCTFail("Failed retrieving balance with error: \(error)")
    }
  }

  func testSendXRP() {
    do {
      _ = try client.send(.testSendAmount, to: .recipientAddress, from: wallet)
    } catch {
      XCTFail("Failed sending XRP with error: \(error)")
    }
  }

  func testSendXRPWithDestinationTag() {
    // GIVEN a transaction hash representing a payment with a destination tag.
    let tag: UInt32 = 123
    let address = "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY"
    let taggedXAddress = Utils.encode(classicAddress: address, tag: tag, isTest: true)!
    let transactionHash = try! client.send(.testSendAmount, to: taggedXAddress, from: wallet)

    // WHEN the payment is retrieved
    let transaction = try! client.getPayment(for: transactionHash)

    // THEN the payment has the correct destination.
    let destinationXAddress = transaction?.paymentFields?.destinationXAddress
    let destinationAddressComponents = Utils.decode(xAddress: destinationXAddress!)!
    XCTAssertEqual(destinationAddressComponents.classicAddress, address)
    XCTAssertEqual(destinationAddressComponents.tag, tag)
  }

  func testPaymentStatus() {
    do {
      let transactionHash = try client.send(.testSendAmount, to: .recipientAddress, from: wallet)
      let transactionStatus = try client.paymentStatus(for: transactionHash)
      XCTAssertEqual(transactionStatus, .succeeded)
    } catch {
      XCTFail("Failed retrieving transaction hash with error: \(error)")
    }
  }

  func testAccountExists() {
    do {
      _ = try client.accountExists(for: wallet.address)
    } catch {
      XCTFail("Failed checking account existence with error: \(error)")
    }
  }

  func testPaymentHistory() {
    do {
      let payments = try client.paymentHistory(for: wallet.address)
      XCTAssert(!payments.isEmpty)
    } catch {
      XCTFail("Failed retrieving payment history with error: \(error)")
    }
  }

  func testGetPayment() {
    do {
      let transactionHash = try client.send(.testSendAmount, to: .recipientAddress, from: wallet)
      let transaction = try client.getPayment(for: transactionHash)
      XCTAssertNotNil(transaction)
    } catch {
      XCTFail("Failed retrieving payment transaction with error: \(error)")
    }
  }

  func testEnableDepositAuth() {
    // GIVEN an existing testnet account, WHEN enableDepositAuth is called
    let result = try! client.enableDepositAuth(for: wallet)

    // THEN the transaction was successfully submitted and the correct flag was set on the account.
    let transactionHash = result.hash
    let transactionStatus = result.status

    // get the account data and check the flag bitmap to see if it was correctly set
    let networkClient = Org_Xrpl_Rpc_V1_XRPLedgerAPIServiceServiceClient(address: .remoteURL, secure: false)

    let address = Utils.decode(xAddress: wallet.address)!.classicAddress
    let account = Org_Xrpl_Rpc_V1_AccountAddress.with {
      $0.address = address
    }

    let ledger = Org_Xrpl_Rpc_V1_LedgerSpecifier.with {
      $0.ledger = Org_Xrpl_Rpc_V1_LedgerSpecifier.OneOf_Ledger.shortcut(.validated)
    }

    let request = Org_Xrpl_Rpc_V1_GetAccountInfoRequest.with {
      $0.account = account
      $0.ledger = ledger
    }

    let accountInfo: Org_Xrpl_Rpc_V1_GetAccountInfoResponse = try! networkClient.getAccountInfo(request)
    let accountData = accountInfo.accountData
    let flags = accountData.flags.value

    XCTAssertNotNil(transactionHash)
    XCTAssertEqual(transactionStatus, .succeeded)
    XCTAssertTrue(AccountRootFlag.check(flag: .lsfDepositAuth, flags: flags))
  }
}
