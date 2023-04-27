/**
	Globals is used to store all the global variables in the game.
	This is usually for stuffs that are loaded on start, or configured on start.

	Ideally, these should "NEVER" be changed after they are loaded.
	Global variable are evil, but sometimes necessary.

	For Constants, see Constants.hx
	For functions, see Utils.hx
**/
class Globals {
	public static var debugger: zf.debug.DebugOverlay;

	public static var game: Game;

	public static var ui: zf.ui.builder.Builder;

	public static var rules: Rules;

	public static var settings: Settings;

	public static var savefile: zf.userdata.Savefile;

	public static var currentProfile: Profile;

#if steamapi
	public static var isSteamInit: Bool = false;
#end

	/**
		Current world
	**/
	public static function currentWorld(): World {
		if (game == null) return null;
		var screen = game.currentScreen;
		if (screen == null) return null;

		if (Std.isOfType(screen, screens.GameScreen)) {
			return cast(screen, screens.GameScreen).world;
		} else if (Std.isOfType(screen, zf.tests.TestScreen)) {
			final ts: zf.tests.TestScreen = cast screen;
			if (ts.selectedTest == null) return null;
			try {
				var tt: tests.WorldTestCase = cast ts.selectedTest.test;
				return tt.world;
			} catch (e) {
				return null;
			}
		}
		return null;
	}
}
