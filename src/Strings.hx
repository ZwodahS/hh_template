class Strings {
	public static var strings: StringTable;

	public static var context: TemplateContext;

	inline public static function get(id: String, context: Dynamic = null): String {
		return Strings.strings.get(id, context);
	}

	public static function initTemplateVariables() {
		Strings.context = new TemplateContext();

		var keywords: DynamicAccess<Dynamic> = {};

		final templates: DynamicAccess<Dynamic> = Strings.strings.conf[Strings.strings.currentLang].get("templates");

		// Load keywords from strings file
		for (id => value in (templates.get("keywords"): DynamicAccess<Dynamic>)) {
			keywords.set(id, (new haxe.Template(value)).execute({}));
		}
		Strings.context.setKeywords(keywords);

		haxe.Template.globals = Strings.context.context;
	}
}
