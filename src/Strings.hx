class Strings {
	public static var strings: StringTable;

	inline public static function get(id: String, context: Dynamic = null): String {
		return Strings.strings.get(id, context);
	}
}
