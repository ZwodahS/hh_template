package world;

typedef WorldStateSF = {
	public var ?intCounter: Int;
	public var ?entities: Array<EntitySF>;
}

class WorldState implements StructSerialisable implements Identifiable {
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

	/**
		identifier
	**/
	public function identifier() {
		return "WorldState";
	}

	var rules: Rules;

	public var entities: Entities<Entity>;

	public function new(rules: Rules, seed: Int = 0) {
		this.rules = rules;
		this.intCounter = new zf.IntCounter.SimpleIntCounter();
		this.r = new hxd.Rand(seed);
		this.entities = new Entities<Entity>();
	}

	// ---- Save / Load ---- //
	public function toStruct(context: SerialiseContext, option: SerialiseOption): WorldStateSF {
		return this.rules.toStruct(context, option, this);
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, data: Dynamic): WorldState {
		this.rules.loadStruct(context, option, this, data);
		return this;
	}
}
