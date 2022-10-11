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
		Collision System / Physics System

		@configure
		We use echo for collision test or we can use the full echo world.
		If we are just using it for collision:
			- Remove EchoSystem
			- Set Echo Component's simulate to false by default or just remove it since it is not used anywhere else.

		If we are not using echo at all:
			- Remove EchoComponent
			- Remove Entity echo component
			- Remove Entity override xy
			- Remove echo from common.hxml
	**/
	public var echoSystem: EchoSystem;

	/**
		World State
	**/
	public var worldState(default, set): WorldState = null;

	public function set_worldState(s: WorldState): WorldState {
		this.worldState = s;
		this.dispatcher.dispatch(new MOnWorldStateSet());
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
		this.addSystem(this.echoSystem = new EchoSystem());
	}

	public function startGame() {}
}
