package abcdefg.rules.entities;

/**
	@stage:stable

	Define a common entity object for the game.
**/
class Entity extends zf.engine2.Entity {
	// ---- Aliases ---- //
	public var world(get, set): World;

	inline function get_world()
		return cast this.__world__;

	inline function set_world(w: World): World {
		this.__world__ = w;
		return w;
	}

	public var rules(get, never): Rules;

	inline public function get_rules(): Rules {
		return cast(this.factory, EntityFactory).rules;
	}

	public var kind(default, null): EntityKind = Unknown;

	// ---- Game Specific code ---- //
	function new(id: Int = -1) {
		super(id);
	}

	override public function dispose() {
		super.dispose();

		this.kind = Unknown;
	}
}

/**
	Mon 13:31:01 15 Jul 2024 Update before working on untitled third game
	Removed the previous comment from here

	A lot code is moved into zf so this can be cleaner.
**/
