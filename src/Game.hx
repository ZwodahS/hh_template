class Game extends zf.Game {
	var version: h2d.HtmlText;
	var bg: h2d.Bitmap;

	override function new() {
		super([640, 360], true, true);
	}

	override function init() {
		Globals.game = this;
		super.init();
#if debug
		Globals.console = this.console;
#end
		this.s2d.scaleMode = Stretch(this.gameWidth, this.gameHeight);

		Assets.load();
		Globals.uiBuilder = new zf.ui.builder.Builder();
		Assets.packed = zf.Assets.loadAseSpritesheetConfig('packed.json');

		Assets.fontZP10x10 = hxd.Res.load('zp10x10_medium_12.fnt').to(hxd.res.BitmapFont);
		Assets.defaultFont = Assets.fontZP10x10.toFont().clone();

		var ss = new SplashScreen();
		ss.onFinish = function() {
			this.switchScreen(new BasicScreen());
		}
		this.switchScreen(ss);

		this.version = new h2d.HtmlText(Assets.defaultFont);
		var versionText = '${Constants.Version}';
		this.version.text = versionText;
		this.version.x = 4;
		this.s2d.add(this.version, 200);

		onResize();
	}

	static function main() {
		try {
#if (js && pak)
			var b = new hxd.net.BinaryLoader("res.pak");
			b.onLoaded = function(bytes) {
				var pak = new hxd.fmt.pak.FileSystem();
				pak.addPak(new hxd.fmt.pak.FileSystem.FileInput(bytes));
				hxd.Res.loader = new hxd.res.Loader(pak);
				new Game();
			}
			b.load();
#elseif (pak && mac)
			var path = haxe.io.Path.directory(Sys.programPath()) + "/../Resources";
			var pak = new hxd.fmt.pak.FileSystem();
			pak.loadPak('${path}/res.pak');
			hxd.Res.loader = new hxd.res.Loader(pak);
			new Game();
#elseif pak
			// this kind of handle ios for now until we specialise it.
			var pak = new hxd.fmt.pak.FileSystem();
			pak.loadPak('res.pak');
			hxd.Res.loader = new hxd.res.Loader(pak);
			new Game();
#elseif hl
			hxd.res.Resource.LIVE_UPDATE = true;
			hxd.Res.initLocal();
			new Game();
#else
			hxd.Res.initLocal();
			new Game();
#end
		} catch (e) {
			Logger.error('${e.stack}');
#if !js
			var logs = [];
			logs.push('${e.stack}');
			logs.push('${e}');
			try {
				sys.io.File.saveContent('crash.log', logs.join("\n"));
			} catch (e) {}
#end
		}
	}

	override function onResize() {
		super.onResize();
		this.version.y = this.gameHeight - 2 - this.version.textHeight;
		if (this.bg != null) this.bg.remove();
		this.bg = new h2d.Bitmap(h2d.Tile.fromColor(Constants.ColorBg, this.gameWidth, this.gameHeight));
		this.s2d.add(this.bg, 0);
	}
}
