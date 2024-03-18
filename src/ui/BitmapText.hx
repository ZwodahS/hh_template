package ui;

/**
	Create a Bitmap display

	Mon 13:04:03 18 Mar 2024
	This uses a prefix system. Each char is converted to a tile '[prefix]:[char]'
**/
class BitmapText extends UIElement {
	var prefix: String;

	public var display: h2d.SpriteBatch;

	public var color: Color = 0xff000000;

	public var text(default, set): String = "";

	public var spacing = 1;

	public var alignment(default, set): zf.h2d.ObjectExtensions.SetMode = AlignCenter;

	public function set_alignment(v: zf.h2d.ObjectExtensions.SetMode): zf.h2d.ObjectExtensions.SetMode {
		this.alignment = v;
		this.display.setX(0, this.alignment);
		return this.alignment;
	}

	public function set_text(v: String): String {
		this.text = v;
		updateString();
		return this.text;
	}

	public function new(prefix: String, color: Color) {
		super();

		this.prefix = prefix;
		this.color = color;

		final tile = A.res.getTile('${prefix}: ');

		this.addChild(this.display = new h2d.SpriteBatch(tile));
	}

	function updateString() {
		this.display.clear();
		var x: Float = 0;
		for (_ => s in this.text) {
			var tile = Assets.res.getTile('${this.prefix}:${String.fromCharCode(s)}');
			if (tile == null) tile = Assets.res.getTile('${this.prefix}: ');
			if (tile == null) continue;
			final be = this.display.alloc(tile);
			be.x = x;
			be.r = color.red / 255;
			be.g = color.green / 255;
			be.b = color.blue / 255;
			be.a = color.alpha / 255;
			x += (tile.width + spacing);
		}
		this.display.setX(0, this.alignment);
	}

	public static function make(prefix: String, color: Color, string: String,
			alignment: zf.h2d.ObjectExtensions.SetMode = null): BitmapText {
		final ui = new BitmapText(prefix, color);
		ui.text = string;
		if (alignment != null) ui.alignment = alignment;
		return ui;
	}
}
