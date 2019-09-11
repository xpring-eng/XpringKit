import Foundation
import JavaScriptCore

/// A javascript implementation of cryptographic utilities.
public class TerramUtilsJS {
    /// The javascript context.
    private let context: JSContext

    /// A reference to the isValidAddress function.
    private let isValidAddressFunction: JSValue

    /// Initialize a new TerramJS.
    ///
    /// - Note: Initialization will fail if the expected bundle is missing or malformed.
    public init?() {
        let bundle = Bundle(for: type(of: self))

        guard
            let context = JSContext(),
            let fileURL = bundle.url(forResource: "bundled", withExtension: "js"),
            let javascript = try? String(contentsOf: fileURL)
            else {
                return nil
        }

        context.evaluateScript(javascript)

        guard
            let entrypoint = context.objectForKeyedSubscript("EntryPoint"),
            let `default` = entrypoint.objectForKeyedSubscript("default"),
            let utils = `default`.objectForKeyedSubscript("Utils"),
            let isValidAddressFunction = utils.objectForKeyedSubscript("isValidAddress"),
            !isValidAddressFunction.isUndefined
            else {
                return nil
        }

        self.context = context

        self.isValidAddressFunction = isValidAddressFunction
    }
}

extension TerramUtilsJS: TerramUtils {
    public func isValid(address: String) -> Bool {
        let result = isValidAddressFunction.call(withArguments: [ address ])!
        return result.toBool()
    }
}
