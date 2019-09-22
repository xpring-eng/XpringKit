import Foundation

/// Provides implementation of common Wallet primitives.
public protocol TerramWallet {
	func getDefaultDerivationPath() -> String

	// TODO(keefer): Hide this behind a protocol.
	func generateRandomWallet() -> JSWallet
	func generateWallet(mnemonic: String) -> JSWallet?
	func generateWallet(mnemonic: String, derivationPath: String) -> JSWallet?
}
