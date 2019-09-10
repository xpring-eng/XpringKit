import Foundation
import JavaScriptCore

public class Terram {
    /// The javascript context.
    private let context: JSContext

    /// Terram objects
    private let isValidAddressFunction: JSValue

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

    public func isValid(address: String) -> Bool {
        let result = isValidAddressFunction.call(withArguments: [ address ])!
        return result.toBool()
    }

//    public func xpring() -> String? {
//            let
//            let result = xpringFn.call(withArguments: nil)
//        else {
//            return nil
//        }
//
//        return result.toString()
//    }
}
