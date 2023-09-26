/**
	Assets is used to store loaded assets
**/
class Assets {
	public static var res: ResourceManager;

	public static var lang: String = "default";

	public static function load() {
		Assets.res = new ResourceManager();
		Assets.res.load("config.json");
	}

	public static function getFont(id: String, sizeIndex: Int): h2d.Font {
		return Assets.res.getFont(Assets.lang, id, sizeIndex);
	}

	public static function fromColor(color: Color, width: Float, height: Float): h2d.Bitmap {
		final bm = new h2d.Bitmap(Assets.res.getTile("white"));
		bm.width = width;
		bm.height = height;
		bm.color.setColor(color);
		return bm;
	}

	public static function loadImage(url: String): h2d.Tile {
		final t = Assets.res.getTile(url);
		return t;
	}
}
