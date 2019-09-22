import Foundation
import JavaScriptCore

@objc public protocol KeyPairProtocol: JSExport {
    var publicKey: String { get }
    var privateKey: String { get }

    init(publicKey: String, privateKey: String)
}

@objc public class KeyPair: NSObject, KeyPairProtocol {
    public let publicKey: String
    public let privateKey: String

    public required init(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}

// TODO(keefer): Remove set?
@objc public protocol WalletProtocol: JSExport {
    var keyPair: KeyPairProtocol { get set }
    var mnemonic: String { get set }
    var derivationPath: String { get set }

    init(keyPair: KeyPairProtocol, mnemonic: String, derivationPath: String)
}

@objc public class Wallet: NSObject, WalletProtocol {
    public dynamic var keyPair: KeyPairProtocol
   	public dynamic var mnemonic: String
    public dynamic var derivationPath: String

    public required init(keyPair: KeyPairProtocol, mnemonic: String, derivationPath: String) {
        self.keyPair = keyPair
        self.mnemonic = mnemonic
        self.derivationPath = derivationPath
    }
}

public class JSWallet {
	private let javascriptWallet: JSValue

	public let publicKey: String
	public let privateKey: String
	public let address: String
	public let mnemonic: String
	public let derivationPath: String

	// TODO: Take a context in here too?
	// TOOD: Shoudl this be failable?
	public init?(value: JSValue) {
		guard
			let publicKey = value.invokeMethod("getPublicKey", withArguments: []),
			let privateKey = value.invokeMethod("getPrivateKey", withArguments: []),
			let address = value.invokeMethod("getAddress", withArguments: []),
			let mnemonic = value.invokeMethod("getMnemonic", withArguments: []),
			let derivationPath = value.invokeMethod("getDerivationPath", withArguments: []),
			!publicKey.isUndefined,
			!privateKey.isUndefined,
			!address.isUndefined,
			!mnemonic.isUndefined,
			!derivationPath.isUndefined
		else {
			return nil
		}

		javascriptWallet = value

		self.publicKey = publicKey.toString()
		self.privateKey = privateKey.toString()
		self.address = address.toString()
		self.mnemonic = mnemonic.toString()
		self.derivationPath = derivationPath.toString()
	}

	public func sign(input: String) -> String? {
		let result = javascriptWallet.invokeMethod("sign", withArguments: [ input ])!
		guard !result.isUndefined else {
			return nil
		}
		return result.toString()
	}

	public func verify() -> Bool {
		return false
	}
}
