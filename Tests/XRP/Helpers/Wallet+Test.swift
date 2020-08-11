import Foundation
import XpringKit

extension Wallet {
  static let testWallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!

  /// Generates a random wallet and funds it using the XRPL Testnet faucet
  static func randomWalletFromFaucet() throws -> Wallet {
    let timeoutInSeconds = 20

    let xrpClient = XRPClient(
      grpcURL: "test.xrp.xpring.io:50051",
      network: XRPLNetwork.test
    )
    let wallet = Wallet.generateRandomWallet(isTest: true).wallet
    let address = wallet.address
    guard let classicAddress = Utils.decode(xAddress: address)?.classicAddress else {
      throw XRPLedgerError.invalidInputs("Could not decode address \(address)")
    }

    // Balance prior to asking for more funds
    let startingBalance: UInt64
    do {
      startingBalance = try xrpClient.getBalance(for: address)
    } catch {
      startingBalance = UInt64(0)
    }

    // Ask the faucet to send funds to the given address
    let faucetURL = "https://faucet.altnet.rippletest.net/accounts"
    let params = ["destination": classicAddress]

    let url = URL(string: faucetURL)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: params)

    let task = URLSession.shared.dataTask(with: request)
    task.resume()

    // Wait for the faucet to fund our account or until timeout
    // Waits one second checks if balance has changed
    // If balance doesn't change it will attempt again until timeoutInSeconds
    var balanceCheckCounter = 0
    while balanceCheckCounter < timeoutInSeconds {
      // wait 1 second
      sleep(1)
      balanceCheckCounter += 1

      // Request our current balance
      let currentBalance: UInt64
      do {
        currentBalance = try xrpClient.getBalance(for: address)
      } catch {
        currentBalance = UInt64(0)
      }
      // If our current balance has changed then return
      if startingBalance != currentBalance {
        return wallet
      }
    }

    // Balance did not update
    throw XRPLedgerError.unknown(
      "Unable to fund address with faucet after waiting \(timeoutInSeconds) seconds"
    )
  }
}
