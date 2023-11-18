/**
	Globals is used to store all the global variables in the game.
	This is usually for stuffs that are loaded on start, or configured on start.

	Ideally, these should "NEVER" be changed after they are loaded.
	Global variable are evil, but sometimes necessary.

	For Constants, see Constants.hx
**/
class Globals {
	public static var debugger: zf.debug.DebugOverlay;

	public static var game: Game;

	public static var ui: zf.ui.builder.Builder;

	public static var settings: Settings;

	public static var savefile: zf.userdata.Savefile;

	public static var currentProfile: Profile;

#if steamapi
	public static var isSteamInit: Bool = false;
#end
}
