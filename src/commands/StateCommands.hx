package commands;

import world.World;
import world.WorldState;

import screens.GameScreen;

import zf.debug.OverlayConsole.ConsoleArg;

class StateCommands {
	public static function setupCommands(game: Game) {
		final stateNames = [];
#if sys
		try {
			for (path in sys.FileSystem.readDirectory("teststate")) {
				stateNames.push(path);
			}
		} catch (e) {}
#end
		{ // save the state
			Globals.debugger.console.addCommand("state.save", "Save the current world state", [
				{
					"name": "path",
					"t": ConsoleArg.AString,
					"opt": true,
				}
			], function(path: String) {
				var currentScreen = game.currentScreen;
				if (Std.isOfType(currentScreen, GameScreen) == false) return;

				var gameScreen: GameScreen = cast currentScreen;
				final world = gameScreen.world;

				if (path == null) {
					world.save();
					return;
				}

				final worldState = world.worldState;
				final userdata = new zf.userdata.UserData("test", "teststate");
				Globals.rules.saveToPath(userdata, worldState, path);
			});
		}

		{ // load the state
			Globals.debugger.console.addCommand("state.load", "", [
				{
					"name": "path",
					"t": ConsoleArg.AString,
					"opt": true,
					"argSuggestions": function(tokenized: Array<String>, arg: String) {
						return zf.StringUtils.findClosestMatch(stateNames, arg);
					}
				}
			], function(path: String) {
				final world = new World(Globals.rules, Globals.currentProfile);
				if (path == null) {
					world.load();
				} else {
					final userdata = new zf.userdata.UserData("test", "teststate");
					try {
						final worldState = Globals.rules.loadFromPath(userdata, path);
						world.worldState = worldState;
					} catch (e) {
						Logger.exception(e);
						return;
					}
				}
				// on load
				var screen = new GameScreen(world);
				game.switchScreen(screen);
			});
		}

		{ // delete a state
			Globals.debugger.console.addCommand("state.delete", "", [
				{
					"name": "path",
					"t": ConsoleArg.AString,
				}
			], function(path: String) {
				final userdata = new zf.userdata.UserData("test", "teststate");
				if (userdata.exists(path) == false) {
					Globals.debugger.console.log('State not found.');
					return;
				}
				userdata.deleteDirectory(path, true);
				Globals.debugger.console.log('State ${path} deleted');
			});
		}

		{ // copy a state from one to another
			Globals.debugger.console.addCommand("state.copy", "Copy a state from one to another via Rules", [
				{
					"name": "loadPath",
					"t": ConsoleArg.AString,
				},
				{
					"name": "savePath",
					"t": ConsoleArg.AString,
				}
			], function(loadPath: String, savePath: String) {
				final userdata = new zf.userdata.UserData("test", "teststate");
				var worldState: WorldState = null;
				try {
					worldState = Globals.rules.loadFromPath(userdata, loadPath);
				} catch (e) {
					Logger.exception(e);
					return;
				}

				final userdata = new zf.userdata.UserData("test", "teststate");
				Globals.rules.saveToPath(userdata, worldState, savePath);
			});
		}
	}
}
