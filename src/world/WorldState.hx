package world;

class WorldState {
	public var r: hxd.Rand;

	// ---- Id generation ---- //

	/**
		Int counter for id generation
	**/
	var intCounter: zf.IntCounter.SimpleIntCounter;

	public var nextId(get, never): Int;

	public function get_nextId(): Int {
		return this.intCounter.getNextInt();
	}

	public var entities: zf.engine2.Entities<Entity>;

	public function new(seed: Int = 0) {
		this.intCounter = new zf.IntCounter.SimpleIntCounter();
		this.r = new hxd.Rand(seed);
		this.entities = new zf.engine2.Entities<Entity>();
	}

	public function addEntity(e: Entity) {
		this.entities.add(e);
	}

	public function removeEntity(e: Entity) {
		this.entities.remove(e);
	}

	public static function newGame(rules: Rules): WorldState {
		final state = new WorldState(Random.int(0, zf.Constants.SeedMax));
		return state;
	}
}
