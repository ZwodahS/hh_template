package abcdefg;

typedef WorldStateSF = {
	> zf.engine2.WorldState.WorldStateSF,
}

#if !macro @:build(zf.macros.Serialise.build()) #end
#if !macro @:build(zf.macros.Engine2.collectEntities()) #end
class WorldState extends zf.engine2.WorldState {
	// ---- Id generation ---- //
	var rules: Rules;

	public function new(rules: Rules, seed: Int = 0) {
		super(seed);
		this.rules = rules;
	}

	override public function getEntityFactory(typeId: String): zf.engine2.EntityFactory {
		return this.rules.entities.get(typeId);
	}
}
/**
	Mon 13:34:11 15 Jul 2024
	Move a lot of logic into zf.engine2.WorldState instead.
**/
