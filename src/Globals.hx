/**
	Globals is used to store all the global variables in the game.
	This is usually for stuffs that are loaded on start, or configured on start.

	Ideally, these should "NEVER" be changed after they are loaded.
	Global variable are evil, but sometimes necessary.

	For Constants, see Constants.hx
	For functions, see Utils.hx
**/
class Globals {
	/**
		Console
	**/
	public static var console: h2d.Console;

	public static var game: Game;

	public static var uiBuilder: zf.ui.builder.Builder;

	public static var rules: Rules;
}
