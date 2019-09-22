import Foundation
import JavaScriptCore

public class JSONMarshaller {
	public let context: JSContext
	public let stringify: JSValue

	// TODO: Context should probably get injected everywhere.
	public init(context: JSContext) {
		self.context = context
		let json = context.objectForKeyedSubscript("JSON")!
		self.stringify = json.objectForKeyedSubscript("stringify")!
	}

	public func marshall(value: JSValue) -> String {
		return stringify.call(withArguments: [ value ])!.toString()
	}
}
