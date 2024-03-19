package abcdefg.rules.proxies;

class Proxy {
	var world: World;

	public var rules(get, never): Rules;

	inline public function get_rules(): Rules {
		return this.world.rules;
	}

	public function new(world: World) {
		this.world = world;
	}
}
