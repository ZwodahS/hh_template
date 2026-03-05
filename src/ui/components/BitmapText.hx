package ui.components;

class BitmapTextComponent extends zf.ui.builder.Component {
	public function new() {
		super("bitmap-text");
	}

	override public function build(element: Xml, context: BuilderContext): zf.ui.builder.ComponentObject {
		final conf = zf.Access.xml(element);
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

		final spacing = conf.getInt("spacing");
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

		final alignment = conf.getString("alignment");
		if (alignment != null) {
			switch (alignment) {
				case "set":
					component.alignment = Set;
				case "anchorLeft":
					component.alignment = AnchorLeft;
				case "anchorRight":
					component.alignment = AnchorRight;
				case "anchorTop":
					component.alignment = AnchorTop;
				case "anchorDown":
					component.alignment = AnchorBottom;
				case "alignCenter":
					component.alignment = AlignCenter;
				default:
			}
		}
		return {object: component};
	}
}
