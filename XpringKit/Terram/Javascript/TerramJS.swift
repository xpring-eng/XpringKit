import Foundation
import JavaScriptCore

/// A javascript implementation of cryptographic utilities.
public class TerramJS {
    public let utils: TerramUtils
    public let wallet: TerramWallet

    public init?() {
        guard
            let utils = TerramUtilsJS(),
            let wallet = TerramWalletJS()
        else {
            return nil
        }

        self.utils = utils
        self.wallet = wallet
    }
}
