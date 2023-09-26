/**
	All the color values
**/
class Colors {
	public static final Blacks: Array<Color> = [0xff111012, 0, 0];
	public static final Whites: Array<Color> = [0, 0, 0xfffffbe5];

	public static final TextColors: Map<String, Map<String, Color>> = [
		"" => [
			// these will be mapped as .XXX
			"white" => 0xfffffbe5,
			"black" => 0xff111012,
		],
		"dark" => ["white" => 0xfffffbe5, "black" => 0xff111012,],
		"light" => ["white" => 0xfffffbe5, "black" => 0xff111012,],
	];

	public static var FlattenColors: Map<String, Color>;

	public static var TemplateColors: Dynamic;

	public static function init() {
		FlattenColors = flattenColors();
		TemplateColors = {
			end: "</font>",
		};
		final dy: DynamicAccess<Dynamic> = TemplateColors;
		for (k => v in FlattenColors) {
			dy.set(k, v);
		}
	}

	public static function getColorKey(key: String, colorId: String): Color {
		final colors: Map<String, Color> = TextColors.get(key);
		if (colors == null) return 0xffffffff;
		return colors.exists(colorId) ? colors.get(colorId) : 0xffffffff;
	}

	inline public static function getColor(colorId): Color {
		return FlattenColors.exists(colorId) ? FlattenColors.get(colorId) : 0xFFFFFFFF;
	}

	inline public static function get(colorId: String): Color {
		return FlattenColors.exists(colorId) ? FlattenColors.get(colorId) : 0xFFFFFFFF;
	}

	public static function flattenColors(): Map<String, Color> {
		final colors: Map<String, Color> = [];
		for (key => tcs in TextColors) {
			final c: Map<String, Color> = cast tcs;
			for (cId => cv in c) {
				if (key == "") colors['${cId}'] = cv; // Also mapped .white to white
				colors['${key}.${cId}'] = cv;
			}
		}
		return colors;
	}

	static function parseColor(color: Int, colorId: String = null): String {
		if (colorId == null) {
			return '<font color="#${StringTools.hex(color & 0xFFFFFF, 6)}">';
		} else {
			return '<font colorId="${colorId}" color="#${StringTools.hex(color & 0xFFFFFF, 6)}">';
		}
	}

	static function colorToDynamic(colors: Array<Color>): Dynamic {
		final d: DynamicAccess<Dynamic> = {};
		for (i => c in colors) {
			d.set('${i}', parseColor(c));
		}
		return d;
	}
}
