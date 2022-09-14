/**
	Assets is used to store loaded assets
**/

import zf.Assets.LoadedSpritesheet;

class Assets {
	public static var bodyFont: hxd.res.BitmapFont;
	public static var bodyFonts: Array<h2d.Font>;

	public static var defaultFont: h2d.Font;

	public static var res: ResourceManager;

	public static function load() {
		Assets.res = new ResourceManager();
		Assets.res.addSpritesheet(zf.Assets.loadAseSpritesheetConfig('graphics/packed.json'));

		final gluten = hxd.Res.load("fonts/gluten-medium.fnt").to(hxd.res.BitmapFont);
		Assets.bodyFont = gluten;
		Assets.bodyFonts = [
			gluten.toSdfFont(4, MultiChannel),
			gluten.toSdfFont(6, MultiChannel),
			gluten.toSdfFont(8, MultiChannel),
			gluten.toSdfFont(10, MultiChannel)
		];

		Assets.defaultFont = Assets.bodyFonts[0];
	}
}
