/**
	Assets is used to store loaded assets
**/

import zf.Assets.LoadedSpritesheet;

class Assets {
	public static var packed: LoadedSpritesheet;

	public static var fontZP10x10: hxd.res.BitmapFont;
	public static var defaultFont: h2d.Font;

	public static var res: ResourceManager;

	public static var strings: StringTable;

	public static function load() {
		Assets.res = new ResourceManager();
		Assets.strings = new StringTable();
	}
}
