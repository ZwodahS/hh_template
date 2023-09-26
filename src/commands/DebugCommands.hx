package commands;

class DebugCommands {
	public static function setupCommands(game: Game) {
#if !js
		Globals.debugger.console.addCommand("reload", "Reload Resources", [], function() {
			hxd.snd.Manager.get().stopAll();
			Globals.game.staticReload();
			Globals.game.switchScreen(new screens.MenuScreen());
			Globals.debugger.hide();
		});
#end
	}
}
