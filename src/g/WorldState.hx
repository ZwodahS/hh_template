package g;

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
		final entities: Entities<Entity> = new Entities<Entity>();
		context.add(entities);

		final stateSF: WorldStateSF = {};

		// store the id generators
		@:privateAccess stateSF.intCounter = this.intCounter.counter;

		// collect all the entities before this is called
		final entitiesSF = [for (entity in entities) entity.toStruct(context, option)];
		stateSF.entities = entitiesSF;

		return stateSF;
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, data: Dynamic): WorldState {
		final stateSF: WorldStateSF = cast data;
		final entitiesSF: Array<EntitySF> = stateSF.entities;
		final entities: Entities<Entity> = new Entities<Entity>();
		context.add(entities);

		for (sf in entitiesSF) {
			final factory = this.rules.entities[sf.typeId];
			if (factory == null) {
				Logger.warn('Fail to load entity, Type: ${sf.typeId}, Id: ${sf.id}');
				continue;
			}
			final entity = factory.load(context, option, sf);
			entities.add(entity);
		}

		// for each of the entities, now we can load the entity proper
		for (sf in entitiesSF) {
			final entity = entities.get(sf.id);
			if (entity == null) continue;
			entity.loadStruct(context, option, sf);
		}

		@:privateAccess this.intCounter.counter = stateSF.intCounter;
		return this;
	}
}