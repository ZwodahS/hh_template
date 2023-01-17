package commands;

import screens.GameScreen;

class StateCommands {
	public static function setupCommands(game: Game) {
		{ // save the state
			Globals.console.addCommand("state.save", "Save the current world state", [
				{
					"name": "path",
					"t": zf.Console.ConsoleArg.AString,
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
			Globals.console.addCommand("state.load", "", [
				{
					"name": "path",
					"t": zf.Console.ConsoleArg.AString,
					"opt": true,
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
			Globals.console.addCommand("state.delete", "", [
				{
					"name": "path",
					"t": zf.Console.ConsoleArg.AString,
				}
			], function(path: String) {
				final userdata = new zf.userdata.UserData("test", "teststate");
				if (userdata.exists(path) == false) {
					Globals.console.log('State not found.');
					return;
				}
				userdata.deleteDirectory(path, true);
				Globals.console.log('State ${path} deleted');
			});
		}

		{ // copy a state from one to another
			Globals.console.addCommand("state.copy", "Copy a state from one to another via Rules", [
				{
					"name": "loadPath",
					"t": zf.Console.ConsoleArg.AString,
				},
				{
					"name": "savePath",
					"t": zf.Console.ConsoleArg.AString,
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
