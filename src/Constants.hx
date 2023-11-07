/**
	Constants are constants value / magic numbers for the game.
	These should be set to be final.

	For the evil globals counterpart, see Globals.hx
	For the function counterpart, see Utils.hx
**/
class Constants {
	/**
		Links
	**/
	public static final MastodonLink = "https://mastodon.gamedev.place/@ZwodahS";

	public static final DiscordLink = "https://discord.gg/BsNrBVf8ev";
	public static final TwitterLink = "https://twitter.com/ZwodahS";

	/**
		Used by savefile
	**/
	public static final GameName: String = "Game";

	public static final Version: zf.Version = zf.Version.fromString("0.0.1");
	public static final GitBuild: String = '${zf.Build.getGitCommitHash()}';

#if steamapi
	public static final SteamAppId = 0;
#end

	public static final TooltipDelay: Float = 0.20;

	public static final HoverDelay: Float = 0.15;
}
