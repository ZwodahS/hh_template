package g;

import g.tests.*;

/**
	WorldGlobals is like Globals, but for this specific game.
**/
class WorldGlobals {
	public static var rules: Rules;

	/**
		Current world
	**/
	public static function currentWorld(): World {
		if (Globals.game == null) return null;
		var screen = Globals.game.currentScreen;
		if (screen == null) return null;

		if (Std.isOfType(screen, GameScreen)) {
			return cast(screen, GameScreen).world;
		} else if (Std.isOfType(screen, zf.tests.TestScreen)) {
			final ts: zf.tests.TestScreen = cast screen;
			if (ts.selectedTest == null) return null;
			try {
				var tt: WorldTestCase = cast ts.selectedTest.test;
				return tt.world;
			} catch (e) {
				return null;
			}
		}
		return null;
	}
}
