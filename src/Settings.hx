typedef SettingsSF = {
	public var ?pixelPerfect: Bool;
	public var ?fullScreen: Bool;
	public var ?language: String;

	public var ?masterVolume: Float;
	public var ?sfxVolume: Float;
	public var ?musicVolume: Float;
	public var ?pauseMusicOnLoseFocus: Bool;
}

class Settings {
	public var pixelPerfect: Bool = true;

	public var fullScreen: Bool = false;

	public var masterVolume(default, set): Float = 0.5;

	public var language: String = null;

	public function set_masterVolume(v: Float): Float {
		this.masterVolume = Math.clampF(v, 0, 1);
		if (this.init == true) hxd.snd.Manager.get().masterVolume = this.masterVolume;
		return this.masterVolume;
	}

	public var sfxVolume(default, set): Float = 0.5;

	public function set_sfxVolume(v: Float): Float {
		this.sfxVolume = Math.clampF(v, 0, 1);
		if (this.init == true) Globals.game.sfxSoundGroup.volume = this.sfxVolume;
		return this.sfxVolume;
	}

	public var musicVolume(default, set): Float = 0.5;

	public function set_musicVolume(v: Float): Float {
		this.musicVolume = Math.clampF(v, 0, 1);
		if (this.init == true) Globals.game.musicSoundGroup.volume = this.musicVolume;
		return this.musicVolume;
	}

	public var pauseMusicOnLoseFocus(default, set): Bool = false;

	public function set_pauseMusicOnLoseFocus(v: Bool): Bool {
		this.pauseMusicOnLoseFocus = v;
		return this.pauseMusicOnLoseFocus;
	}

	public var init: Bool = false;

	public function new() {}

	public static function fromStruct(sf: SettingsSF): Settings {
		final settings = new Settings();
		if (sf.pixelPerfect != null) settings.pixelPerfect = sf.pixelPerfect;
		if (sf.fullScreen != null) settings.fullScreen = sf.fullScreen;
		if (sf.masterVolume != null) settings.masterVolume = sf.masterVolume;
		if (sf.musicVolume != null) settings.musicVolume = sf.musicVolume;
		if (sf.sfxVolume != null) settings.sfxVolume = sf.sfxVolume;
		if (sf.pauseMusicOnLoseFocus != null) settings.pauseMusicOnLoseFocus = sf.pauseMusicOnLoseFocus;
		if (sf.language != null) settings.language = sf.language;
		settings.init = true;
		return settings;
	}

	public function toStruct(): SettingsSF {
		return {
			pixelPerfect: this.pixelPerfect,
			fullScreen: this.fullScreen,
			masterVolume: this.masterVolume,
			musicVolume: this.musicVolume,
			language: this.language,
			pauseMusicOnLoseFocus: this.pauseMusicOnLoseFocus,
			sfxVolume: this.sfxVolume,
		}
	}

	public function save() {
		Globals.savefile.userdata.saveToPath('settings.json', haxe.Json.stringify(this.toStruct(), "  "));
	}
}
