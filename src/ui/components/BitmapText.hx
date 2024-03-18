package ui.components;

class BitmapTextComponent extends zf.ui.builder.Component {
	public function new() {
		super("bitmap-text");
	}

	override public function makeFromStruct(s: Dynamic, context: BuilderContext): h2d.Object {
		return make(zf.Access.struct(s), context);
	}

	override public function makeFromXML(element: Xml, context: BuilderContext): h2d.Object {
		return make(zf.Access.xml(element), context);
	}

	function make(conf: zf.Access, context: BuilderContext): h2d.Object {
		final prefix = conf.getString("prefix");
		// handles string id, useful for localisation

		var textColor: Color = 0xffffffff;

		final textColorKey = conf.getString("textColorKey");
		var textColorString: String = null;
		if (textColorKey != null) {
			textColorString = context.get(textColorKey);
		} else {
			textColorString = conf.getString("textColor");
		}

		if (textColorString != null) {
			final parsed = Std.parseInt(textColorString);
			if (parsed == null) {
				textColor = context.builder.getColor(textColorString);
			} else {
				textColor = parsed;
			}
		}

		final component = new BitmapText(prefix, textColor);

		var spacing = conf.getInt("spacing");
		if (spacing != null) component.spacing = spacing;

		var hasText = false;
		if (conf.get("stringId") != null) {
			final stringId = conf.get("stringId");
			// take from context first if the string Id exist
			var string: String = cast context.get(stringId);
			// if stringId not found, we take it from the builder's StringTemplate
			if (string == null) {
				final template = context.builder.getStringTemplate(stringId);
				if (template != null) string = context.formatTemplate(template);
			} else {
				string = context.formatTemplate(new haxe.Template(string));
			}
			if (string != null) {
				component.text = string;
				hasText = true;
			}
		} else if (conf.get("text") != null) {
			component.text = conf.getString("text");
		}
		return component;
	}
}
