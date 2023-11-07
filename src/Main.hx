class Main {
	// ---- Main Method ---- //
	static function main() {
#if steamapi
		trace('Initialising Steam Api....');
		// init steam
		Globals.isSteamInit = steam.Api.init(Constants.SteamAppId);
		trace('Steam Api: ${Globals.isSteamInit}');
#end

#if (!debug && hl)
		/**
			Tue 21:38:22 07 Nov 2023
			This is still bugged in hl
		**/
		hl.UI.closeConsole();
#end

		/**
			Set up loggers
		**/
		zf.Logger.init();

#if debug
		zf.Logger.addConsoleLogger();
		zf.Logger.addFileLogger('logs/debug.log', null, 0);
#end
		zf.Logger.addFileLogger('logs/log.log', 10, null);
		zf.Logger.addFileLogger('crash.log', 100, null);

		Globals.savefile = new zf.userdata.Savefile(Constants.GameName, "userdata");
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
		Globals.settings.init = true;
		Globals.settings.save();

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
#elseif (pak && mac && steam)
			var pak = new hxd.fmt.pak.FileSystem();
			pak.loadPak('res.pak');
			hxd.Res.loader = new hxd.res.Loader(pak);
			new Game();
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
			hxd.res.Resource.LIVE_UPDATE = false;
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
}
