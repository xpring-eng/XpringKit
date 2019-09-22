import XCTest
import XpringKit

class TerramWalletJSTest: XCTestCase {
    private var terramWallet: TerramWallet!

    override func setUp() {
        super.setUp()

        guard let terramWallet = TerramWalletJS() else {
            XCTFail("Could not instantiate Terram :( Check for a missing Javascript resource?")
            return
        }

        self.terramWallet = terramWallet
    }

    func testDefaultDerivationPath() {
        XCTAssertEqual(self.terramWallet.getDefaultDerivationPath(), "m/44'/144'/0'/0/0")
    }

	func testGenerateRandomWallet() {
		let wallet = self.terramWallet.generateRandomWallet()
		XCTAssertNotNil(wallet)
		XCTAssertEqual(wallet.derivationPath, self.terramWallet.getDefaultDerivationPath())
	}

	func testGenerateWalletFromMnemonicNoDerivationPath() {
		let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
		guard let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic) else {
			XCTFail("Could not generate wallet")
			return
		}

		XCTAssertEqual(wallet.mnemonic, mnemonic)
		XCTAssertEqual(wallet.derivationPath, self.terramWallet.getDefaultDerivationPath())
		XCTAssertEqual(wallet.publicKey, "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE")
		XCTAssertEqual(wallet.privateKey, "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4")
		XCTAssertEqual(wallet.address, "rHsMGQEkVNJmpGWs8XUBoTBiAAbwxZN5v3")
	}

	func testGenerateWalletFromMnemonicDerivationPath0() {
		let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
		let derivationPath = "m/44'/144'/0'/0/0"
		guard let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
			XCTFail("Could not generate wallet")
			return
		}

		XCTAssertEqual(wallet.mnemonic, mnemonic)
		XCTAssertEqual(wallet.derivationPath, derivationPath)
		XCTAssertEqual(wallet.publicKey, "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE")
		XCTAssertEqual(wallet.privateKey, "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4")
		XCTAssertEqual(wallet.address, "rHsMGQEkVNJmpGWs8XUBoTBiAAbwxZN5v3")
	}

	func testGenerateWalletFromMnemonicDerivationPath1() {
		let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
		let derivationPath = "m/44'/144'/0'/0/1"
		guard let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
			XCTFail("Could not generate wallet")
			return
		}

		XCTAssertEqual(wallet.mnemonic, mnemonic)
		XCTAssertEqual(wallet.derivationPath, derivationPath)
		XCTAssertEqual(wallet.publicKey, "038BF420B5271ADA2D7479358FF98A29954CF18DC25155184AEAD05796DA737E89")
		XCTAssertEqual(wallet.privateKey, "000974B4CFE004A2E6C4364CBF3510A36A352796728D0861F6B555ED7E54A70389")
		XCTAssertEqual(wallet.address, "r3AgF9mMBFtaLhKcg96weMhbbEFLZ3mx17")
	}

	func testGenerateWalletFromMnemonicInvalidDerivationPath() {
		let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
		let derivationPath = "invalid_path"
		let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic, derivationPath: derivationPath)
		XCTAssertNil(wallet)
	}

	func testGenerateWalletFromMnemonicInvalidMnemonic() {
		let mnemonic = "xrp xrp xrp xrp xrp xrp xrp xrp xrp xrp xrp xrp"
		let derivationPath = "m/44'/144'/0'/0/1"
		let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic, derivationPath: derivationPath)
		XCTAssertNil(wallet)
	}

	func testSign() {
		let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
		let derivationPath = "m/44'/144'/0'/0/0"
		guard let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
			XCTFail("Could not generate wallet")
			return
		}

		let result = wallet.sign(input: "74657374206d657373616765")
		XCTAssertNotNil(result)
		XCTAssertEqual(result, "3045022100E10177E86739A9C38B485B6AA04BF2B9AA00E79189A1132E7172B70F400ED1170220566BD64AA3F01DDE8D99DFFF0523D165E7DD2B9891ABDA1944E2F3A52CCCB83A")
	}

	func testSignInvalidHex() {
		let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
		let derivationPath = "m/44'/144'/0'/0/0"
		guard let wallet = self.terramWallet.generateWallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
			XCTFail("Could not generate wallet")
			return
		}

		XCTAssertNil(wallet.sign(input: "xrp"))
	}
}
