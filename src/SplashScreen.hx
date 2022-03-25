using zf.h2d.ObjectExtensions;

import zf.animations.Wait;
import zf.animations.Func;
import zf.animations.AlphaTo;
import zf.animations.WrappedObject;
import zf.animations.Animator;

class SplashScreen extends zf.Screen {
	public static final WaitDuration: Float = #if debug 0.5; #else 1.5; #end

	var bm: h2d.Bitmap;
	var bg: h2d.Bitmap;

	public var animator: Animator;

	public function new() {
		super();
		this.bg = new h2d.Bitmap(h2d.Tile.fromColor(0xFF203037, Globals.game.gameWidth,
			Globals.game.gameHeight));
		this.addChild(bg);
		this.animator = new Animator();
		final tile = hxd.Res.load("sproutingpotato.png").toTile();
		this.bm = new h2d.Bitmap(tile);
		bm.setX(Globals.game.gameWidth, AlignCenter).setY(Globals.game.gameHeight, AlignCenter);
		this.addChild(bm);
		animator.runAnim(new Wait(WaitDuration).then(new AlphaTo(new WrappedObject(this.bm), 0, 1.0 / .5))
			.then(new Wait(0.2))
			.then(new Func(function(dt: Float) {
				this.onFinish();
				return true;
			})));
	}

	override public function update(dt: Float) {
		this.animator.update(dt);
	}

	dynamic public function onFinish() {}
}
