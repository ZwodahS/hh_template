package world;

class World extends zf.engine2.World {
	/**
		Store the main rule object
	**/
	public var rules: Rules;

	// ---- Systems ---- //

	/**
		Main rendering system
	**/
	public var renderSystem: RenderSystem;

	/**
		World State
	**/
	public var worldState(default, set): WorldState = null;

	public function set_worldState(s: WorldState): WorldState {
		this.worldState = s;
		this.dispatcher.dispatch(MOnWorldStateSet.alloc()).dispose();
		for (e in this.worldState.entities) {
			this.registerEntity(e);
		}
		return this.worldState;
	}

	public var nextId(get, never): Int;

	inline function get_nextId(): Int {
		return this.worldState == null ? 0 : this.worldState.nextId;
	}

	/**
		User Profile
	**/
	public var profile: Profile;

	/**
		World simulation speed.
	**/
	public var worldSpeed: Float = 1;

	public function new(rules: Rules, profile: Profile) {
		super();
		this.rules = rules;
		this.profile = profile;

		this.addSystem(this.renderSystem = new RenderSystem());
	}

	public function startGame() {}

	public function save() {
		final fullpath = this.profile.profile.path("world");
		this.rules.saveToPath(Globals.savefile.userdata, this.worldState, fullpath);
	}

	public function load() {
		final fullPath = this.profile.profile.path("world");
		final worldState = this.rules.loadFromPath(Globals.savefile.userdata, fullPath);
		this.worldState = worldState;
	}
}
