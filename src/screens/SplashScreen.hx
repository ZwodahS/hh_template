package screens;

using zf.h2d.ObjectExtensions;
using zf.up.animations.WrappedObject;

import zf.up.Updater;
import zf.up.animations.AlphaTo;

class SplashScreen extends zf.Screen {
	public static final WaitDuration: Float = #if debug 0.5; #else 1.5; #end

	var bm: h2d.Bitmap;
	var bg: h2d.Bitmap;

	public var updater: Updater;

	public function new() {
		super();
		this.bg = new h2d.Bitmap(h2d.Tile.fromColor(0xFF203037, Globals.game.gameWidth, Globals.game.gameHeight));
		this.addChild(bg);
		this.updater = new Updater();
		final tile = hxd.Res.load("sproutingpotato.png").toTile();
		this.bm = new h2d.Bitmap(tile);
		bm.setX(Globals.game.gameWidth, AlignCenter).setY(Globals.game.gameHeight, AlignCenter);
		this.addChild(bm);
		updater.wait(WaitDuration)
			.then(new AlphaTo(this.bm.wo(), 0, 1.0 / .5))
			.wait(0.2)
			.whenDone(() -> {
				onFinish();
			});
	}

	override public function update(dt: Float) {
		this.updater.update(dt);
	}

	override public function onScreenEntered() {
		onStart();
	};

	dynamic public function onStart() {}

	dynamic public function onFinish() {}
}
