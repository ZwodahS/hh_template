class Game extends zf.Game {
	override function init() {
		Globals.game = this;
		super.init();
#if debug
		Globals.console = this.console;
#end
		this.s2d.scaleMode = Stretch(Globals.gameWidth, Globals.gameHeight);

		Assets.packed = zf.Assets.loadAseSpritesheetConfig('packed.json');

		this.switchScreen(new examples.AnimationScene());
	}

	static function main() {
#if (js && pak)
		var b = new hxd.net.BinaryLoader("res.pak");
		b.onLoaded = function(bytes) {
			var pak = new hxd.fmt.pak.FileSystem();
			pak.addPak(new hxd.fmt.pak.FileSystem.FileInput(bytes));
			hxd.Res.loader = new hxd.res.Loader(pak);
			new Game();
		}
		b.load();
#elseif pak
		hxd.Res.initPak();
		new Game();
#elseif hl
		hxd.res.Resource.LIVE_UPDATE = true;
		hxd.Res.initLocal();
		new Game();
#else
		hxd.Res.initEmbed();
		new Game();
#end
	}
}
