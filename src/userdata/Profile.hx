package userdata;

/**
	Store the information regarding the state of the world.
**/
typedef WorldSaveSF = {
	public var exists: Bool;
}

typedef ProfileSF = {
	public var version: Int;
	public var worldsave: WorldSaveSF;
}

/**
	Profile stores the profile of a player.
	In a run based game, this will store the stats of the players.
	In a save-based game, we should still store this as a general stats, and use worldsavesf to store each save.
**/
class Profile {
	public static final Version = 1;

	public final profile: zf.userdata.UserProfile;

	public var worldsaveSF: WorldSaveSF;

	public function new(profile: zf.userdata.UserProfile) {
		this.profile = profile;
		this.worldsaveSF = {exists: false};
	}

	public function load() {
		final result = this.profile.loadStruct("save.json");
		final sf: ProfileSF = switch (result) {
			case SuccessContent(data): data;
			default: defaultConf();
		}
		if (sf == null) return;

		this.worldsaveSF = sf.worldsave;
	}

	/**
		The default conf
	**/
	function defaultConf(): ProfileSF {
		return {
			version: Version,
			worldsave: {exists: false},
		}
	}

	public function save() {
		final sf: ProfileSF = {
			version: Version,
			worldsave: this.worldsaveSF,
		}
		this.profile.saveStruct("save.json", sf);
	}

	public function deleteWorld() {
		this.worldsaveSF.exists = false;
		this.save();
	}
}
