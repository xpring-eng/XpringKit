import Foundation
import JavaScriptCore

public class Terram {
    private let context: JSContext

    public init?() {
        guard let context = JSContext() else {
            return nil
        }

        let bundle = Bundle(for: type(of: self))
        guard let fileURL = bundle.url(forResource: "primitives", withExtension: "js") else {
            return nil
        }

        guard let javascript = try? String(contentsOf: fileURL) else {
            return nil
        }

        context.evaluateScript(javascript)

        self.context = context
    }

    public func xpring() -> String? {
        guard let xpringFn = context.objectForKeyedSubscript("xpring") else {
            return nil
        }

        return xpringFn.call(withArguments: nil)?.toString()
    }
}
