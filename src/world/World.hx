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
		this.resetWorld();
		this.dispatcher.dispatch(new MOnWorldStateSet());
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

	public function new(rules: Rules, profile: Profile) {
		super();
		this.rules = rules;
		this.profile = profile;

		this.addSystem(this.renderSystem = new RenderSystem());
	}

	public function resetWorld() {}
}
