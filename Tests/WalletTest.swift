import XCTest
import XpringKit

class WalletTest: XCTestCase {
  func testGenerateMainNetWalletFromSeed() {
    guard let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB") else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertNotNil(wallet)
    XCTAssertEqual(wallet.address, "XVnJMYQFqA8EAijpKh5EdjEY5JqyxykMKKSbrUX8uchF6U8")
  }

  func testGenerateTestNetWalletFromSeed() {
    guard let wallet = Wallet(seed: "snYP7oArxKepd3GPDcrjMsJYiJeJB", isTest: true) else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertNotNil(wallet)
    XCTAssertEqual(wallet.address, "T7zFmeZo6uLHP4Vd21TpXjrTBk487ZQPGVQsJ1mKWGCD5rq")
  }

  func testGenerateWalletFromInvalidSeed() {
    let wallet = Wallet(seed: "xrp")
    XCTAssertNil(wallet)
  }

  func testGenerateRandomWallet() {
    let walletGenerationResult = Wallet.generateRandomWallet()
    XCTAssertEqual(walletGenerationResult.derivationPath, Wallet.defaultDerivationPath)
  }

  func testGenerateWalletFromMnemonicNoDerivationPath() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    guard let wallet = Wallet(mnemonic: mnemonic) else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertEqual(wallet.publicKey, "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE")
    XCTAssertEqual(wallet.privateKey, "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4")
    XCTAssertEqual(wallet.address, "XVMFQQBMhdouRqhPMuawgBMN1AVFTofPAdRsXG5RkPtUPNQ")
  }

  func testGenerateMainNetWalletFromMnemonicDerivationPath0() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertEqual(wallet.publicKey, "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE")
    XCTAssertEqual(wallet.privateKey, "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4")
    XCTAssertEqual(wallet.address, "XVMFQQBMhdouRqhPMuawgBMN1AVFTofPAdRsXG5RkPtUPNQ")
  }

  func testGenerateTestNetWalletFromMnemonicDerivationPath0() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath, isTest: true) else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertEqual(wallet.publicKey, "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE")
    XCTAssertEqual(wallet.privateKey, "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4")
    XCTAssertEqual(wallet.address, "TVHLFWLKvbMv1LFzd6FA2Bf9MPpcy4mRto4VFAAxLuNpvdW")
  }

  func testGenerateWalletFromMnemonicDerivationPath1() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/1"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertEqual(wallet.publicKey, "038BF420B5271ADA2D7479358FF98A29954CF18DC25155184AEAD05796DA737E89")
    XCTAssertEqual(wallet.privateKey, "000974B4CFE004A2E6C4364CBF3510A36A352796728D0861F6B555ED7E54A70389")
    XCTAssertEqual(wallet.address, "X7uRz9jfzHUFEjZTZ7rMVzFuTGZTHWcmkKjvGkNqVbfMhca")
  }

  func testGenerateWalletFromMnemonicInvalidDerivationPath() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "invalid_path"
    let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath)
    XCTAssertNil(wallet)
  }

  func testGenerateWalletFromMnemonicInvalidMnemonic() {
    let mnemonic = "xrp xrp xrp xrp xrp xrp xrp xrp xrp xrp xrp xrp"
    let derivationPath = "m/44'/144'/0'/0/1"
    let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath)
    XCTAssertNil(wallet)
  }

  func testSign() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
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
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    XCTAssertNil(wallet.sign(input: "xrp"))
  }

  func testVerify() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    let message = "74657374206d657373616765"
    let signature = "3045022100E10177E86739A9C38B485B6AA04BF2B9AA00E79189A1132E7172B70F400ED1170220566BD64AA3F01DDE8D99DFFF0523D165E7DD2B9891ABDA1944E2F3A52CCCB83A"

    XCTAssertTrue(wallet.verify(message: message, signature: signature))
  }

  func testVerifyInvalidSignature() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    let message = "74657374206d657373616765"
    let signature = "DEADBEEF"

    XCTAssertFalse(wallet.verify(message: message, signature: signature))
  }

  func testVerifyBadMessage() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    let message = "xrp"
    let signature = "3045022100E10177E86739A9C38B485B6AA04BF2B9AA00E79189A1132E7172B70F400ED1170220566BD64AA3F01DDE8D99DFFF0523D165E7DD2B9891ABDA1944E2F3A52CCCB83A"

    XCTAssertFalse(wallet.verify(message: message, signature: signature))
  }

  func testSignAndVerifyEmptyString() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    let message = ""

    guard let signature = wallet.sign(input: message) else {
      XCTFail("Failed to sign message")
      return
    }
    XCTAssertTrue(wallet.verify(message: message, signature: signature))
  }

  func testVerifyEmptyStringBadSignature() {
    let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    let derivationPath = "m/44'/144'/0'/0/0"
    guard let wallet = Wallet(mnemonic: mnemonic, derivationPath: derivationPath) else {
      XCTFail("Could not generate wallet")
      return
    }

    let message = ""
    let signature = "DEADBEEF"

    XCTAssertFalse(wallet.verify(message: message, signature: signature))
  }

  func testGenerateWalletFromKeys() {
    // GIVEN a set of well formed keys.
    let publicKey = try! "031D68BC1A142E6766B2BDFB006CCFE135EF2E0E2E94ABB5CF5C9AB6104776FBAE".toBytes()
    let privateKey = try! "0090802A50AA84EFB6CDB225F17C27616EA94048C179142FECF03F4712A07EA7A4".toBytes()

    // WHEN a wallet is generated THEN it is constructed successfully.
    XCTAssertNotNil(Wallet(publicKey: publicKey, privateKey: privateKey, isTest: false))
  }
}
