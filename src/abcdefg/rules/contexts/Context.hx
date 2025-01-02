package abcdefg.rules.contexts;

class Context {
	var world: World;

	function new() {}

	public function reset() {
		this.world = null;
	}

	// ---- Standard Function ---- //
	public function randomInt(max: Int): Int {
		return this.world.r.randomInt(max);
	}

	public function floorInt(f: Float): Int {
		return Std.int(Math.floor(f));
	}

	public function ceilInt(f: Float): Int {
		return Std.int(Math.ceil(f));
	}
}
