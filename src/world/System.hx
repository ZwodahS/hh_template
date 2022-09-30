package world;

class System extends zf.engine2.System {
	// ---- Aliases ---- //
	public var world(get, never): World;

	inline function get_world()
		return cast this.__world__;

	// ---- Game Specific code ---- //
	override public function init(world: zf.engine2.World) {
		super.init(world);
	}
}
