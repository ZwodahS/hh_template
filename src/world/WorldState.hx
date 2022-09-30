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

	public function new(seed: Int = 0) {
		this.intCounter = new zf.IntCounter.SimpleIntCounter();
		this.r = new hxd.Rand(seed);
	}
}
