package world;

class Entity extends zf.engine2.Entity {
	// ---- Aliases ---- //
	public var world(get, never): World;

	inline function get_world()
		return cast this.__world__;

	// ---- Game Specific code ---- //
	public function new(id: Int = -1) {
		super(id);
	}
}
