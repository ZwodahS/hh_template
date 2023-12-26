/**
	All the color values
**/
class Colors {
	public static var TemplateColors: Dynamic;

	public static function init() {
		if (TemplateColors == null) TemplateColors = {};

		final dy: DynamicAccess<Dynamic> = TemplateColors;
		for (k => _ in dy) {
			dy.remove(k);
		}

		dy.set("end", "</font>");
		for (k => v in Assets.res.colors) {
			dy.set(k, parseColor(v, k));
		}
	}

	inline public static function getColor(id: String): Color {
		return Assets.res.getColor(id);
	}

	static function parseColor(color: Int, colorId: String = null): String {
		if (colorId == null) {
			return '<font color="#${StringTools.hex(color & 0xFFFFFF, 6)}">';
		} else {
			return '<font colorId="${colorId}" color="#${StringTools.hex(color & 0xFFFFFF, 6)}">';
		}
	}
}
