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

print(wallet.address) // rHsMGQEkVNJmpGWs8XUBoTBiAAbwxZN5v3
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

A `XpringClient` can check the balance of an account on the ledger.

```swift
import XpringKit

let remoteURL = "grpc.xpring.tech:80"
let xpringClient = new XpringClient(grpcURL: remoteURL)

let address = "rHsMGQEkVNJmpGWs8XUBoTBiAAbwxZN5v3"

let balance = try! xpringClient.getBalance(for: address)
print(balance.drops) // Logs a balance in drops of XRP
```

#### Sending XRP

A `XpringClient` can send XRP to other accounts on the ledger.

```swift
import XpringKit

let remoteURL = "grpc.xpring.tech:80"
let xpringClient = XpringClient(grpcURL: remoteURL)

// Wallet which will send XRP
let generationResult = Wallet.generateRandomWallet()!

// Destination address.
let address = "rHsMGQEkVNJmpGWs8XUBoTBiAAbwxZN5v3"

// Amount of XRP to send
let amount = XRPAmount.with { $0.drops = "10" }

let result = try! xpringClient.send(amount, to: destinationAddress, from: senderWallet)
```

### Utilities
#### Address validation

The Utils object provides an easy way to validate addresses.

```swift
import XpringKit

let rippleAddress = rnysDDrRXxz9z66DmCmfWpq4Z5s4TyUP3G
let bitcoinAddress = 1DiqLtKZZviDxccRpowkhVowsbLSNQWBE8

Utils.isValid(address: rippleAddress); // returns true
Utils.isValid(address: bitcoinAddress); // returns false
```

## Development
To get set up for development on XpringKit, use the following steps:

```shell
# Clone repository
$ git clone https://github.com/xpring-eng/xpringkit.git
$ cd xpringkit

# Pull submodules
$ git submodule init
$ git submodule update --remote

# Install required tooling
$ brew install xcodegen swiftlint carthage swift-protobuf grpc-swift

# Generate project
$ ./scripts/generate_project.sh
```
