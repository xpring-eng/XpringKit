[![CircleCI](https://img.shields.io/circleci/build/github/xpring-eng/XpringKit/master?style=flat-square)](https://circleci.com/gh/xpring-eng/XpringKit/tree/master)
[![CodeCov](https://img.shields.io/codecov/c/github/xpring-eng/xpringkit/master?style=flat-square&token=08b799e2895a4dd6add40c4621880c1a)]((https://codecov.io/gh/xpring-eng/xpringkit))

# XpringKit

XpringKit is the Swift client side library of the Xpring SDK.

## Features
XpringKit provides the following features:
- Wallet generation and derivation (Seed or HD Wallet based)
- Address validation
- Account balance retrieval
- Sending XRP payments

## Installation
### Client Side Library

#### Carthage
XpringKit is available via [Carthage](https://github.com/Carthage/Carthage). Simply add the following to your `Cartfile`:

```
github "xpring-eng/XpringKit"
```

#### CocoaPods

XpringKit is available via [CocoaPods](https://cocoapods.org/). Simply add the following to your `Podfile`:

```
pod 'XpringKit'
```

### rippled Node

Xpring SDK needs to communicate with a rippled node which has gRPC enabled. Consult the [rippled documentation](https://github.com/ripple/rippled#build-from-source) for details on how to build your own node.

To get developers started right away, Xpring currently provides nodes:

```
# Testnet
test.xrp.xpring.io:50051

# Mainnet
main.xrp.xpring.io:50051
```

### Hermes Node
Xpring SDK's `IlpClient` needs to communicate with Xpring's ILP infrastructure through an instance of [Hermes](https://github.com/xpring-eng/hermes-ilp).   

In order to connect to the Hermes instance that Xpring currently operates, you will need to create an ILP wallet [here](https://xpring.io/portal/ilp-wallet)

Once your wallet has been created, you can use the gRPC URL specified in your wallet, as well as your **access token** to check your balance
and send payments over ILP.

## Usage: XRP

**Note:** Xpring SDK only works with the X-Address format. For more information about this format, see the [Utilities section](#utilities) and <http://xrpaddress.info>.

### Wallets
A wallet is a fundamental model object in XpringKit which provides key management, address derivation, and signing functionality. Wallets can be derived from either a seed or a mnemonic and derivation path. You can also choose to generate a new random HD wallet.

#### Wallet Derivation
XpringKit can derive a wallet from a seed or it can derive a hierarchical deterministic wallet (HDWallet) from a mnemonic and derivation path.

##### Hierarchical Deterministic Wallets
A hierarchical deterministic wallet is created using a mnemonic and a derivation path. Simply pass the mnemonic and derivation path to the wallet generation function. Note that you can omit the derivation path and have a default path be used instead.

```swift
import XpringKit

let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"

let hdWallet1 = Wallet.generateWalletFromMnemonic(mnemonic: mnemonic)! // Has default derivation path
let hdWallet2 = Wallet(mnemonic: mnemonic, derivationPath: Wallet.defaultDerivationPath)! // Same as hdWallet1

let hdWallet = Wallet(mnemonic: mnemonic, derivationPath: "m/44'/144'/0'/0/1"); // Wallet with custom derivation path.
```

##### Seed Based Wallets
You can construct a seed based wallet by passing a base58check encoded seed string.

```swift
import XpringKit

let seedWallet = Wallet(seed: "snRiAJGeKCkPVddbjB3zRwiYDBm1M")!
```

#### Wallet Generation
XpringKit can generate a new and random HD Wallet. The result of a wallet generation call is a tuple which contains the following:
- A randomly generated mnemonic
- The derivation path used, which is the default path
- A reference to the new wallet

```swift
import XpringKit

// Generate a random wallet.
let generationResult = Wallet.generateRandomWallet()!
let newWallet = generationResult.wallet

// Wallet can be recreated with the artifacts of the initial generation.
let copyOfNewWallet = Wallet(mnemonic: generationResult.mnemonic, derivationPath: generationResult.derivationPath)
```

#### Wallet Properties
A generated wallet can provide its public key, private key, and address on the XRP ledger.

```swift
import XpringKit

let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about";

let wallet = Wallet(mnemonic: mnemonic)!

print(wallet.address) // XVMFQQBMhdouRqhPMuawgBMN1AVFTofPAdRsXG5RkPtUPNQ
print(wallet.publicKey) // 031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE
print(wallet.privateKey) // 0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4
```

#### Signing / Verifying

A wallet can also sign and verify arbitrary hex messages. Generally, users should use the functions on `XRPClient` to perform cryptographic functions rather than using these low level APIs.

```swift
import XpringKit

let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
let message = "deadbeef";

let wallet = Wallet(mnemonic: mnemonic)!

let signature = wallet.sign(message)
wallet.verify(message, signature); // true
```

### XRPClient

`XRPClient` is a gateway into the XRP Ledger. `XRPClient` is initialized with a single parameter, which is the URL of the remote adapter (see: ‘Server Side Component’ section above).

```swift
import XpringKit

let remoteURL = "test.xrp.xpring.io:50051"; // Testnet URL, use main.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, network: XRPLNetwork.test)
```

#### Retrieving a Balance

An `XRPClient` can check the balance of an account on the XRP Ledger.

```swift
import XpringKit

let remoteURL = "test.xrp.xpring.io:50051"; // Testnet URL, use main.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, network: XRPLNetwork.test)

let address = "XVMFQQBMhdouRqhPMuawgBMN1AVFTofPAdRsXG5RkPtUPNQ"

let balance = try! xrpClient.getBalance(for: address)
print(balance) // Logs a balance in drops of XRP
```

### Checking Payment Status

An `XRPClient` can check the status of an payment on the XRP Ledger.

This method can only determine the status of [payment transactions](https://xrpl.org/payment.html) which do not have the partial payment flag ([tfPartialPayment](https://xrpl.org/payment.html#payment-flags)) set.

XpringKit returns the following transaction states:
- `succeeded`: The transaction was successfully validated and applied to the XRP Ledger.
- `failed:` The transaction was successfully validated but not applied to the XRP Ledger. Or the operation will never be validated.
- `pending`: The transaction has not yet been validated, but may be validated in the future.
- `unknown`: The transaction status could not be determined, the hash represented a non-payment type transaction, or the hash represented a transaction with the [tfPartialPayment](https://xrpl.org/payment.html#payment-flags) flag set.

**Note:** For more information, see [Reliable Transaction Submission](https://xrpl.org/reliable-transaction-submission.html) and [Transaction Results](https://xrpl.org/transaction-results.html).

These states are determined by the `TransactionStatus` enum.

```swift
import XpringKit

let remoteURL = "test.xrp.xpring.io:50051"; // Testnet URL, use main.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, network: XRPLNetwork.test)

let transactionHash = "9FC7D277C1C8ED9CE133CC17AEA9978E71FC644CE6F5F0C8E26F1C635D97AF4A"

let transactionStatus = xrpClient.paymentStatus(for: transactionHash) // TransactionStatus.succeeded
```

**Note:** The example `transactionHash` may lead to a "Transaction not found." error because the TestNet is regularly reset, or the accessed node may only maintain one month of history.  Recent transaction hashes can be found in the [XRP Ledger Explorer ](https://livenet.xrpl.org/).

#### Retrieve specific payment

An `XRPClient` can retrieve a specific payment transaction by hash.

```swift
import XpringKit

let remoteURL = "alpha.test.xrp.xpring.io:50051"; // TestNet URL, use alpha.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, network: XRPLNetwork.test)

let transactionHash = "9FC7D277C1C8ED9CE133CC17AEA9978E71FC644CE6F5F0C8E26F1C635D97AF4A"
let payment = try! xrpClient.getPayment(for: transactionHash)
```

**Note:** The example `transactionHash` may lead to a "Transaction not found." error because the TestNet is regularly reset, or the accessed node may only maintain one month of history.  Recent transaction hashes can be found in the [XRP Ledger Explorer ](https://livenet.xrpl.org/).

#### Retrieve speciic payment

An `XRPClient` can retrieve a specific payment transaction by hash.

```
import xpringkit

let remoteURL = "alpha.test.xrp.xpring.io:50051"; // TestNet URL, use alpha.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, useNewProtocolBuffers: true)

let transactionHash = "9FC7D277C1C8ED9CE133CC17AEA9978E71FC644CE6F5F0C8E26F1C635D97AF4A"
let payment = try! xrpClient.getPayment(for: transactionHash)
```

**Note:** The example transactionHash may lead to a "Transaction not found." error because the TestNet is regularly reset, or the accessed node may only maintain one month of history.  Recent transaction hashes can be found in the [XRP Ledger Explorer ](https://livenet.xrpl.org/).

#### Payment history

An `XRPClient` can return payments to and from an account.

```
import XpringKit

let remoteURL = "alpha.test.xrp.xpring.io:50051"; // TestNet URL, use alpha.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, network: XRPLNetwork.test)

let address = "XVMFQQBMhdouRqhPMuawgBMN1AVFTofPAdRsXG5RkPtUPNQ"

let transactions = try! xrpClient.paymentHistory(for: address)
```

#### Sending XRP

An `XRPClient` can send XRP to other accounts on the XRP Ledger.

**Note:** The payment operation will block the calling thread until the operation reaches a definitive and irreversible success or failure state.

```swift
import XpringKit

let remoteURL = "test.xrp.xpring.io:50051"; // TestNet URL, use main.xrp.xpring.io:50051 for Mainnet
let xrpClient = XRPClient(grpcURL: remoteURL, network: XRPLNetwork.test)

// Wallet which will send XRP
let generationResult = Wallet.generateRandomWallet()!
let senderWallet = generationResult.wallet

// Destination address.
let address = "X7u4MQVhU2YxS4P9fWzQjnNuDRUkP3GM6kiVjTjcQgUU3Jr"

// Amount of XRP to send, in drops.
let amount: UInt64 = 10

let transactionHash = try! xrpClient.send(amount, to: destinationAddress, from: senderWallet)
```

**Note:** The above example will yield an "Account not found." error because
the randomly generated wallet contains no XRP.

### Utilities
#### Address validation

The Utils object provides an easy way to validate addresses.

```swift
import XpringKit

let rippleClassicAddress = "rnysDDrRXxz9z66DmCmfWpq4Z5s4TyUP3G"
let rippleXAddress = "X7jjQ4d6bz1qmjwxYUsw6gtxSyjYv5iWPqPEjGqqhn9Woti"
let bitcoinAddress = "1DiqLtKZZviDxccRpowkhVowsbLSNQWBE8"

Utils.isValid(address: rippleAddress); // returns true
Utils.isValid(address: bitcoinAddress); // returns false
```

You can also validate if an address is an X-Address or a classic address.
```swift
import XpringKit

let rippleClassicAddress = "rnysDDrRXxz9z66DmCmfWpq4Z5s4TyUP3G"
let rippleXAddress = "X7jjQ4d6bz1qmjwxYUsw6gtxSyjYv5iWPqPEjGqqhn9Woti"
let bitcoinAddress = "1DiqLtKZZviDxccRpowkhVowsbLSNQWBE8"

Utils.isValidXAddress(address: rippleClassicAddress); // returns false
Utils.isValidXAddress(address: rippleXAddress); // returns true
Utils.isValidXAddress(address: bitcoinAddress); // returns false

Utils.isValidClassicAddress(address: rippleClassicAddress); // returns true
Utils.isValidClassicAddress(address: rippleXAddress); // returns false
Utils.isValidClassicAddress(address: bitcoinAddress); // returns false
```

### X-Address Encoding

You can encode and decode X-Addresses with the SDK.

```swift
import XpringKit

let rippleClassicAddress = "rnysDDrRXxz9z66DmCmfWpq4Z5s4TyUP3G"
let tag: UInt32 = 12345;

// Encode an X-Address.
let xAddress = Utils.encode(classicAddress: address, tag: tag) // X7jjQ4d6bz1qmjwxYUsw6gtxSyjYv5xRB7JM3ht8XC4P45P

// Decode an X-Address.
let classicAddressTuple = Utils.decode(xAddress: address)!
print(classicAddressTuple.classicAddress); // rnysDDrRXxz9z66DmCmfWpq4Z5s4TyUP3G
print(classicAddressTuple.tag); // 12345
```

## Usage: PayID

Two classes are used to work with PayID: `PayIDClient` and `XRPPayIDClient`.

### PayIDClient
#### Single Address Resolution

`PayIDClient` can resolve addresses on arbitrary cryptocurrency networks.

```swift
import XpringKit

// Resolve on Bitcoin Mainnet.
let network = "btc-mainnet"
let payIDClient = PayIDClient()
let payID = "georgewashington$xpring.money"

let result = payIDClient.cryptoAddress(for: payID, on: network)
switch result {
case .success(let btcAddressComponents)
  print("Resolved to \(btcAddressComponents.address)")
case .failure(let error):
  fatalError("Unknown error resolving address: \(error)")
}

#### Single Address Resolution

`PayIdClient` can retrieve all available addresses.

```swift
import XpringKit

let payID = "georgewashington$xpring.money"
let payIDClient = new PayIDClient()

let allAddresses = payIDClient.allAddresses(for: payID)
case .success(let addresses)
  print("All addresses: \(allAddresses)")
case .failure(let error):
  fatalError("Unknown error retrieving all addresses: \(error)")
}
```

Asynchronous APIs are also provided.

### XRPPayIDClient

`XRPPayIDClient` can resolve addresses on the XRP Ledger network. The class always coerces returned addresses into an X-Address. (See https://xrpaddress.info/)

```swift
import XpringKit

// Use XrplNetwork.main for Mainnet.
let xrpPayIDClient = XRPPayIDClient(xrplNetwork: .main)

let payID = 'georgewashington$xpring.money'
let result = xrpPayIDClient.xrpAddress(for: payID)
switch result {
case .success(let xrpAddress):
  print("Resolved to \(xrpAddress)")
case .failure(let error):
  fatalError("Unknown error resolving address: \(error)")
}
```

Asynchronous APIs are also provided.

## Usage: ILP
### ILPClient
`ILPClient` is the main interface into the ILP network.  `ILPClient` must be initialized with the URL of a Hermes instance.
This can be found in your [wallet](https://xpring.io/portal/ilp-wallet).

All calls to `ILPClient` must pass an access token, which can be generated in your [wallet](https://xpring.io/portal/ilp-wallet).

```swift
import XpringKit

let grpcUrl = "hermes-grpc-test.xpring.dev" // TestNet Hermes URL
let ilpClient = ILPClient(grpcURL: grpcUrl)
```

#### Retreiving a Balance
An `ILPClient` can check the balance of an account on a connector.

```swift
import XpringKit

let grpcUrl = "hermes-grpc-test.xpring.dev" // TestNet Hermes URL
let ilpClient = ILPClient(grpcURL: grpcUrl)

let getBalance = try ilpClient.getBalance(for: "demo_user", withAuthorization: "2S1PZh3fEKnKg") // Just a demo user on Testnet
print("Net balance was \(getBalance.netBalance) with asset scale \(getBalance.assetScale)")
```

#### Sending a Payment
An `ILPClient` can send an ILP payment to another ILP address by supplying a [Payment Pointer](https://github.com/interledger/rfcs/blob/master/0026-payment-pointers/0026-payment-pointers.md)
and a sender's account ID.

```swift
import XpringKit

let grpcUrl = "hermes-grpc-test.xpring.dev" // TestNet Hermes URL
let ilpClient = ILPClient(grpcURL: grpcUrl)

let paymentRequest = PaymentRequest(
    100,
    to: "$xpring.money/demo_receiver",
    from: "demo_user"
)
let payment = try ilpClient.sendPayment(
    paymentRequest,
    withAuthorization: "2S1PZh3fEKnKg"
)
```

## Usage: Xpring

Xpring components compose PayID and XRP components to make complex interactions easy.

```swift
import XpringKit

let network = XRPLNetwork.test

// Build an XRPClient
let rippledUrl = "test.xrp.xpring.io:50051"
let xrpClient = XRPClient(rippledUrl, network)

// Build a PayIDClient
let payIDClient = XRPPayIDClient(network)

// XpringClient combines functionality from XRP and PayID
let xpringClient = XpringClient(payIdClient, xrpClient)

// A wallet with some balance on TestNet.
let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB")!

// A PayID which will receive the payment.
let payId = "georgewashington$xpring.money"

// Send XRP to the given PayID.
let result = xpringClient.send(dropsToSend, to: payID, from: wallet)
switch result {
case .success(let hash):
  print("Hash for transaction:\n\(hash)\n")
case .failure:
  fatalError("Unable to send transaction.")
}
```

Asynchronous APIs are also provided.

# Contributing

Pull requests are welcome! To get started with building this library and opening pull requests, please see [contributing.md](CONTRIBUTING.md).

Thank you to all the users who have contributed to this library!

<a href="https://github.com/xpring-eng/xpringkit/graphs/contributors">
  <img src="https://contributors-img.firebaseapp.com/image?repo=xpring-eng/xpringkit" />
</a>

# License

Xpring SDK is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
