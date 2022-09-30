typedef SettingsSF = {
	public var ?pixelPerfect: Bool;
	public var ?fullScreen: Bool;
}

class Settings {
	public var pixelPerfect: Bool = true;
	public var fullScreen: Bool = false;

	public function new() {}

	public static function fromStruct(sf: SettingsSF): Settings {
		final settings = new Settings();
		if (sf.pixelPerfect != null) settings.pixelPerfect = sf.pixelPerfect;
		if (sf.fullScreen != null) settings.fullScreen = sf.fullScreen;
		return settings;
	}

	public function toStruct(): SettingsSF {
		return {
			pixelPerfect: this.pixelPerfect,
			fullScreen: this.fullScreen,
		}
	}

	public function save() {
		Globals.savefile.userdata.saveToPath('settings.json', haxe.Json.stringify(this.toStruct(), "  "));
	}
}
