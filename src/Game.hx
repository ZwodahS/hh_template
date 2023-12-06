class Game extends zf.Game {
	public var sound: Sounds;

	override public function new() {
		super([640, 360], true, true);

		this.sound = new Sounds();
	}

	override function init() {
		G.game = this;
		// load assets first before init
		initAssets();
		super.init();

		/**
			Set up various globals variable
		**/
		// @:privateAccess s2d.events.defaultCursor = Assets.cursors["default"];
		UIElement.defaultHoverDelay = C.HoverDelay;

		// set up the debug overlay
#if debug
		// set up the overlay
		this.debugOverlay = new zf.debug.DebugOverlay(this);
		this.debugOverlay.fonts = A.getFonts("debug");
		this.debugOverlay.init();
		/**
			If we have more than one type of "game" in the same project, we will have to add them here
		**/
		this.debugOverlay.inspector.getManagedObjects = () -> {
			var objects: Array<{name: String, object: Dynamic}> = [];
			final world = g.WorldGlobals.currentWorld();
			if (world != null) objects.push({name: "world", object: world});

			objects.push({name: "game", object: this});
			objects.push({name: "Globals", object: Globals.Globals});
			return objects;
		}
		Globals.debugger = this.debugOverlay;
#end

		// @fixme this is a weird fix. On pak + mac, the main loop lacks something that blocks the main loop
		// from exiting, hence by adding this, we allow the sound to run
		@:privateAccess haxe.MainLoop.add(() -> {});

		if (Globals.settings.language == null) {
			Globals.settings.language = "en";
		}
		initStringTables();
		initBuilder();
		initH2d();

		this.engine.backgroundColor = 0xff111012;

		this.toggleFullScreen(Globals.settings.fullScreen);

		initRules();
		try {
			// in case user data fails to load
			Globals.currentProfile = new userdata.Profile(Globals.savefile.userProfiles.getProfile("save-1"));
			Globals.currentProfile.load();
			Globals.currentProfile.save();
		} catch (e) {
			onException(e, haxe.CallStack.exceptionStack());
			return;
		}

#if debug
		commands.DebugCommands.setupCommands(this);
		final testNames = TestSetup.getTestNames();
		zf.tests.TestCommands.makeScreen = TestSetup.makeTestScreen;
		zf.tests.TestCommands.setupCommands(this, Globals.debugger.console, testNames);
		g.commands.StateCommands.setupCommands(this);
		g.commands.GameCommands.setupCommands(this);
#end

		var args = [];
#if sys
		args = Sys.args();
#end
		parseAndRun(args);
	}

#if debug
	override function getDebugFont(): h2d.Font {
		return A.getFont("debug", 0);
	}
#end

#if !js
	public function staticReload() {
		hxd.Res.initLocal();
		initAssets();
		initStringTables();
		initBuilder();
		initH2d();
		initRules();
	}
#end

	function initAssets() {
		Assets.load();
		Colors.init();
	}

	function initStringTables() {
		Strings.initTemplateVariables();
	}

	function initBuilder() {
		G.ui = new zf.ui.builder.Builder();
		G.ui.getStringTemplate = S.getTemplate;
		G.ui.getString = (id, context) -> {
			return S.get(id, context);
		}
		G.ui.res = A.res;
		G.ui.getColor = K.getColor;
		G.ui.formatString = (str, context) -> {
			final t = new haxe.Template(str);
			return t.execute(context.data);
		}

		zf.ui.builder.XmlComponent.Builder = G.ui;

		// setup ui builder
		CompileTime.importPackage("ui.components");
		final classes = CompileTime.getAllClasses("ui.components", true, zf.ui.builder.Component);
		for (c in classes) Globals.ui.registerComponent(Type.createInstance(c, []));
		Globals.ui.getFont = (name: String) -> {
			try {
				final splits = name.split(".");
				Assets.getFont(splits[0], Std.parseInt(splits[1]));
			} catch (e) {
				return hxd.res.DefaultFont.get().clone();
			}
		}
	}

	function initH2d() {
		h2d.HtmlText.defaultLoadImage = (url) -> {
			return Assets.res.getTile(url);
		};
		zf.h2d.HtmlText.defaultLoadImage = (url) -> {
			return Assets.res.getTile(url);
		};
		zf.h2d.HtmlText.defaultFormatText = (text) -> {
			return text.replace("\n", "<br/>");
		}
		zf.h2d.HtmlText.defaultGetColor = Colors.getColorKey.bind("dark");
	}

	function initRules() {
		try {
			// in case the rules loading failed
			g.WorldGlobals.rules = new g.Rules();
		} catch (e) {
			onException(e, haxe.CallStack.exceptionStack());
			return;
		}
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

	// ---- Handles Exceptions ---- //
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
			logs.push(zf.Debug.stackItemToString(s));
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

	override public function update(dt: Float) {
		super.update(dt);
		this.sound.update(dt);
	}

	override function onEvent(e: hxd.Event) {
		super.onEvent(e);
		switch (e.kind) {
			case EFocus:
				this.sound.soundManager.suspended = false;
			case EFocusLost:
				if (Globals.settings.pauseMusicOnLoseFocus == true) this.sound.soundManager.suspended = true;
			default:
		}
	}
}
