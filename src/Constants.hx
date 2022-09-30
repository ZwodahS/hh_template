/**
	Constants are constants value / magic numbers for the game.
	These should be set to be final.

	For the evil globals counterpart, see Globals.hx
	For the function counterpart, see Utils.hx
**/
class Constants {
	public static final Version: zf.Version = zf.Version.fromString("0.0.1");
	public static final GitBuild: String = '${zf.Build.getGitCommitHash()}';

	public static final ColorBg = 0x14182e;

#if steamapi
	public static final SteamAppId = 0;
#end
}
