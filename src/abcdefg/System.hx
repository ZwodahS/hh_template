package abcdefg;

class System extends zf.engine2.System {
	// ---- Aliases ---- //
	public var world(get, never): World;

	public function get_world(): World {
		return cast this.__world__;
	}

	public var rules(get, never): Rules;

	public function get_rules(): Rules {
		return this.world.rules;
	}

	public var worldState(get, never): WorldState;

	public function get_worldState(): WorldState {
		return this.world.worldState;
	}
}
