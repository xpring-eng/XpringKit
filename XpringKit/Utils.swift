public enum Utils {
	public static func isValid(address: Address) -> Bool {
		return UtilsJS()!.isValid(address: address)
	}
}
