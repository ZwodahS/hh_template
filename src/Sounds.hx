/**
	Manage all the sounds
**/
class Sounds {
	static var instance: Sounds = null;

	public var musicSoundGroup: hxd.snd.SoundGroup;
	public var sfxSoundGroup: hxd.snd.SoundGroup;
	public var soundManager: hxd.snd.Manager;

	public var sfx: Map<String, Bool> = [];

	public function new() {
		this.musicSoundGroup = new hxd.snd.SoundGroup("music");
		this.musicSoundGroup.volume = Math.clampF(Globals.settings.musicVolume, 0, 1.0);
		this.sfxSoundGroup = new hxd.snd.SoundGroup("sfx");
		this.sfxSoundGroup.volume = Math.clampF(Globals.settings.sfxVolume, 0, 1.0);
		this.soundManager = hxd.snd.Manager.get();
		this.soundManager.masterVolume = Math.clampF(Globals.settings.masterVolume, 0, 1.0);

		Sounds.instance = this;
	}

	public function update(dt: Float) {
		this.sfx.clear();
	}

	public static function playMusic(name: String, loop: Bool = true): hxd.snd.Channel {
		if (Sounds.instance == null) return null;
		final s = Assets.res.getSound(name);
		if (s == null) return null;
		return s.play(loop, null, Sounds.instance.musicSoundGroup);
	}

	public static function playSfx(name: String, volume: Float = 1.0): hxd.snd.Channel {
		if (Sounds.instance == null) return null;
		final s = Assets.res.getSound(name);
		if (s == null) return null;
		// if the sfx has been played this frame, we don't play it again
		if (Sounds.instance.sfx.exists(name) == true) return null;
		final channel = s.play(false, null, Sounds.instance.sfxSoundGroup);
		Sounds.instance.sfx[name] = true;

		return channel;
	}
}
