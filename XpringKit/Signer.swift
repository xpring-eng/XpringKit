public class Signer {
	private let jsSigner: JSSigner

	public init() {
		jsSigner = JSSigner()!
	}

	public func sign(_ transaction: Io_Xpring_Transaction, with wallet: Wallet) -> Io_Xpring_SignedTransaction? {
		return jsSigner.sign(transaction, with: wallet)
	}
}
