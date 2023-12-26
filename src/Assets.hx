/**
	Assets is used to store loaded assets
**/
class Assets {
	public static var res: ResourceManager;

	public static function load() {
		Assets.res = new ResourceManager();
		Assets.res.load("config.hs");
	}

	inline public static function getFont(id: String, sizeIndex: Int): h2d.Font {
		return Assets.res.getFont(G.settings.language, id, sizeIndex);
	}

	inline public static function getFonts(id: String): Array<h2d.Font> {
		return Assets.res.getFonts(G.settings.language, id).fonts;
	}

	public static function fromColor(color: Color, width: Float, height: Float): h2d.Bitmap {
		final bm = new h2d.Bitmap(Assets.res.getTile("white"));
		bm.width = width;
		bm.height = height;
		bm.color.setColor(color);
		return bm;
	}
}
