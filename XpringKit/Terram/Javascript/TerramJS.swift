import Foundation
import JavaScriptCore

/// A javascript implementation of cryptographic utilities.
public class TerramJS {
    public let utils: TerramUtils

    public init?() {
        guard let utils = TerramUtilsJS() else {
            return nil
        }
        self.utils = utils
    }
}
