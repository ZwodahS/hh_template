class Game extends zf.Game {
	var version: h2d.HtmlText;
	var bg: h2d.Bitmap;

	override function new() {
		super([320, 180], true, true);
	}

	override function init() {
		Globals.game = this;
		super.init();

#if debug
		Globals.console = this.console;
#end

		// @fixme this is a weird fix. On pak + mac, the main loop lacks something that blocks the main loop
		// from exiting, hence by adding this, we allow the sound to run
		@:privateAccess haxe.MainLoop.add(() -> {});

		Assets.load();
		Strings.strings = new StringTable();
		Globals.uiBuilder = new zf.ui.builder.Builder();
		Globals.settings = new Settings();

		CompileTime.importPackage("ui.components");
		final classes = CompileTime.getAllClasses("ui.components", true, zf.ui.builder.Component);
		for (c in classes) {
			Globals.uiBuilder.registerComponent(Type.createInstance(c, []));
		}

		this.version = new h2d.HtmlText(Assets.defaultFont);
		this.version.text = '${Constants.Version}.${Constants.GitBuild.substr(0, 8)}';
		this.s2d.add(this.version, 200);
		updateVersionPosition();
		this.toggleFullScreen(Globals.settings.fullScreen);

		var args = [];
#if sys
		args = Sys.args();
#end
		parseAndRun(args);
	}

	static function main() {
#if steamapi
		// init steam
		Globals.isSteamInit = steam.Api.init(Constants.SteamAppId);
#end

#if (!debug && hl)
		hl.UI.closeConsole();
#end

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

	function parseAndRun(args: Array<String>) {
		if (args.length != 0) {
			switch (args[0]) {
				// handle command line args if any
				default:
			}
		}

		final screen = new screens.SplashScreen();
		screen.onFinish = function() {
			this.switchScreen(new screens.MenuScreen());
		}
		this.switchScreen(screen);
	}

	function updateVersionPosition() {
		this.version.setX(this.gameWidth, AnchorRight, 2);
		this.version.setY(this.gameHeight, AnchorBottom, 2);
	}
}
