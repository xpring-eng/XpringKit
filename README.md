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

XpringKit utilizes two components to access the Xpring platform:
1) The XpringKit client side library (This library)
2) A server side component that handles requests from this library and proxies them to an XRP node

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

### Server Side Component
The server side component sends client-side requests to an XRP Node.

To get developers started right away, Xpring currently provides the server side component as a hosted service, which proxies requests from client side libraries to a a hosted XRP Node. Developers can reach the endpoint at:
```
grpc.xpring.tech:80
```

Xpring is working on building a zero-config way for XRP node users to deploy and use the adapter as an open-source component of [rippled](https://github.com/ripple/rippled). Watch this space!

## Usage

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

A wallet can also sign and verify arbitrary hex messages. Generally, users should use the functions on `XpringClient` to perform cryptographic functions rather than using these low level APIs.

```swift
import XpringKit

let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
let message = "deadbeef";

let wallet = Wallet(mnemonic: mnemonic)!

let signature = wallet.sign(message)
wallet.verify(message, signature); // true
```

### XpringClient

`XpringClient` is a gateway into the XRP Ledger. `XpringClient` is initialized with a single parameter, which is the URL of the remote adapter (see: ‘Server Side Component’ section above).

```swift
import XpringKit

let remoteURL = "grpc.xpring.tech:80"
let xpringClient = XpringClient(grpcURL: remoteURL)
```

#### Retrieving a Balance

A `XpringClient` can check the balance of an account on the XRP Ledger.

```swift
import XpringKit

let remoteURL = "grpc.xpring.tech:80"
let xpringClient = new XpringClient(grpcURL: remoteURL)

let address = "XVMFQQBMhdouRqhPMuawgBMN1AVFTofPAdRsXG5RkPtUPNQ"

let balance = try! xpringClient.getBalance(for: address)
print(balance) // Logs a balance in drops of XRP
```

### Checking Transaction Status

A `XpringClient` can check the status of an transaction on the XRP Ledger. 

XpringKit returns the following transaction states:
- `succeeded`: The transaction was successfully validated and applied to the XRP Ledger.
- `failed:` The transaction was successfully validated but not applied to the XRP Ledger. Or the operation will never be validated.
- `pending`: The transaction has not yet been validated, but may be validated in the future.
- `unknown`: The transaction status could not be determined.

**Note:** For more information, see [Reliable Transaction Submission](https://xrpl.org/reliable-transaction-submission.html) and [Transaction Results](https://xrpl.org/transaction-results.html).

These states are determined by the `TransactionStatus` enum.

```swift
import XpringKit

let remoteURL = "grpc.xpring.tech:80"
let xpringClient = new XpringClient(grpcURL: remoteURL)

let transactionHash = "9FC7D277C1C8ED9CE133CC17AEA9978E71FC644CE6F5F0C8E26F1C635D97AF4A"

let transactionStatus = xpringClient.getTransactionStatus(for: transactionHash) // TransactionStatus.succeeded
```

**Note:** The example transactionHash may lead to a "Transaction not found." error because the TestNet is regularly reset, or the accessed node may only maintain one month of history.  Recent transaction hashes can be found in the [XRP Ledger Explorer ](https://livenet.xrpl.org/).

#### Sending XRP

A `XpringClient` can send XRP to other accounts on the XRP Ledger.

**Note:** The payment operation will block the calling thread until the operation reaches a definitive and irreversible success or failure state.

```swift
import XpringKit

let remoteURL = "grpc.xpring.tech:80"
let xpringClient = XpringClient(grpcURL: remoteURL)

// Wallet which will send XRP
let generationResult = Wallet.generateRandomWallet()!
let senderWallet = generationResult.wallet

// Destination address.
let address = "X7u4MQVhU2YxS4P9fWzQjnNuDRUkP3GM6kiVjTjcQgUU3Jr"

// Amount of XRP to send, in drops.
let amount: UInt64 = 10

let transactionHash = try! xpringClient.send(amount, to: destinationAddress, from: senderWallet)
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

# Contributing

Pull requests are welcome! To get started with building this library and opening pull requests, please see [contributing.md](CONTRIBUTING.md).

Thank you to all the users who have contributed to this library!

<a href="https://github.com/xpring-eng/xpringkit/graphs/contributors">
  <img src="https://contributors-img.firebaseapp.com/image?repo=xpring-eng/xpringkit" />
</a>

# License

Xpring SDK is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
