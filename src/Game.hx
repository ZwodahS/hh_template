class Game extends zf.Game {
	var version: h2d.HtmlText;

	override function new() {
		super([640, 360], true, true);
	}

	override function init() {
		Globals.game = this;
		Assets.load();
		super.init();

#if debug
		Globals.console = this.console;
#end

		// @fixme this is a weird fix. On pak + mac, the main loop lacks something that blocks the main loop
		// from exiting, hence by adding this, we allow the sound to run
		@:privateAccess haxe.MainLoop.add(() -> {});

		Strings.strings = new StringTable();
		Strings.strings.load("en", "strings/en/strings.json");
		Strings.initTemplateVariables();
		Globals.uiBuilder = new zf.ui.builder.Builder();

		CompileTime.importPackage("ui.components");
		final classes = CompileTime.getAllClasses("ui.components", true, zf.ui.builder.Component);
		for (c in classes) {
			Globals.uiBuilder.registerComponent(Type.createInstance(c, []));
		}

		this.version = new h2d.HtmlText(Assets.displayFonts[2]);
		this.version.text = '${Constants.Version}.${Constants.GitBuild.substr(0, 8)}';
		this.s2d.add(this.version, 200);
		updateVersionPosition();

		this.toggleFullScreen(Globals.settings.fullScreen);

		try {
			// in case the rules loading failed
			Globals.rules = new Rules();

			// in case user data fails to load
			Globals.currentProfile = new userdata.Profile(Globals.savefile.userProfiles.getProfile("save-1"));
			Globals.currentProfile.load();
		} catch (e) {
			onException(e, haxe.CallStack.exceptionStack());
			return;
		}

#if debug
		DebugCommands.setupDebugCommands(this);
		commands.StateCommands.setupCommands(this);
		final testNames = TestSetup.getTestNames();
		zf.tests.TestCommands.makeScreen = TestSetup.makeTestScreen;
		zf.tests.TestCommands.setupCommands(this, Globals.console, testNames);
#end

		var args = [];
#if sys
		args = Sys.args();
#end
		parseAndRun(args);
	}

#if debug
	override function getDebugFont(): h2d.Font {
		return Assets.debugFonts[1];
	}
#end

	static function main() {
#if steamapi
		// init steam
		Globals.isSteamInit = steam.Api.init(Constants.SteamAppId);
#end

#if (!debug && hl)
		hl.UI.closeConsole();
#end

		Globals.savefile = new zf.userdata.Savefile("Game", "userdata");
		Globals.savefile.init();

		Globals.settings = new Settings();
		if (Globals.savefile.userdata.exists('settings.json')) {
			final result = Globals.savefile.userdata.loadFromPath('settings.json');
			final data = switch (result) {
				case SuccessContent(d): d;
				default: null;
			};
			if (data == null) {
				Logger.warn("fail to load settings", "[Init]");
			} else {
				final sf = haxe.Json.parse(data);
				Globals.settings = Settings.fromStruct(sf);
			}
		}

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

	override function onException(e: haxe.Exception, s: Array<haxe.CallStack.StackItem>) {
		if (Std.isOfType(e, zf.exceptions.AssertionFail)) {
			throw e;
		}
		writeException(e, s);
#if !js
		hxd.System.exit();
#end
	}

	static function writeException(e: haxe.Exception, stackItems: Array<haxe.CallStack.StackItem>) {
		Logger.exception(e);
#if !js
		var logs = [];
		logs.push('--------------------------------');
		logs.push('Build: ${Constants.Version}-${Constants.GitBuild}');
		for (s in stackItems) {
			logs.push(Utils.stackItemToString(s));
		}
		logs.push('--------------------------------');
		logs.push(e.details());
		logs.push('--------------------------------');
		logs.push('');
		try {
			final fileout = sys.io.File.append('crash.log', false);
			fileout.writeString(logs.join("\n"));
			fileout.flush();
			fileout.close();
		} catch (e) {}
#end
	}

	function parseAndRun(args: Array<String>) {
		if (args.length != 0) {
			switch (args[0]) {
				case "rt", "runtest":
					args.shift();
					runtest(args);
					return;
				default:
			}
		}

		final screen = new screens.SplashScreen();
		screen.onFinish = function() {
			this.switchScreen(new screens.MenuScreen());
		}
		this.switchScreen(screen);
	}

	function runtest(args: Array<String>) {
		// open the first item
		if (args.length == 0) return;
		final screen = TestSetup.makeTestScreen();
		switchScreen(screen);
		screen.runCommand(args);
	}

	function updateVersionPosition() {
		this.version.setX(this.gameWidth, AnchorRight, 2);
		this.version.setY(this.gameHeight, AnchorBottom, 2);
	}
}
