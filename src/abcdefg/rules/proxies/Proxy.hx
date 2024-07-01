package abcdefg.rules.proxies;

class Proxy {
	var world: World;

	public var rules(get, never): Rules;

	inline public function get_rules(): Rules {
		return this.world.rules;
	}

	function new() {}

	public function reset() {
		this.world = null;
	}
}
