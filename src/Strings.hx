class Strings {
	public static var context: TemplateContext;

	inline public static function get(id: String, context: Dynamic = null, fallback: Array<String> = null,
			logError: Bool = true): String {
		return Assets.res.stringTable.get(id, G.settings.language, context, fallback, logError);
	}

	inline public static function getTemplate(id: String) {
		return Assets.res.stringTable.getTemplate(id, G.settings.language);
	}

	public static function initTemplateVariables() {
		Strings.context = new TemplateContext();
		haxe.Template.globals = Strings.context.context;

		final keywords: DynamicAccess<Dynamic> = {};

		for (conf in Assets.res.stringTable.confs[G.settings.language]) {
			final rk: DynamicAccess<Dynamic> = (conf: DynamicAccess<Dynamic>).get("keywords");
			for (id => kw in (rk: DynamicAccess<Dynamic>)) {
				final dkw: DynamicAccess<Dynamic> = kw;
				final text = dkw.get("text");
				if (text == null) continue;
				var storeString = new haxe.Template('::c.keyword::${text}::c.end::').execute({});
				if (dkw.get("tooltip") != null) {
					storeString = '<interactive name="keywords.${id}">${storeString}</interactive>';
				}
				keywords.set(id, storeString);
			}
			Strings.context.setKeywords(keywords);
		}
	}
}
