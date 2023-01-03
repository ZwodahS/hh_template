package world.factories;

class EntityFactory {
	public var rules: Rules;
	public var typeId: String;

	public function new(typeId: String, rules: Rules) {
		this.typeId = typeId;
		this.rules = rules;
	}

	public function make(id: Int, worldState: WorldState, conf: Dynamic = null): Entity {
		throw new zf.exceptions.NotImplemented();
	}

	public function toStruct(context: SerialiseContext, option: SerialiseOption, entity: Entity): Dynamic {
		throw new zf.exceptions.NotImplemented();
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, entity: Entity,
			data: Dynamic): Entity {
		throw new zf.exceptions.NotImplemented();
	}

	public function load(context: SerialiseContext, option: SerialiseOption, data: Dynamic): Entity {
		final worldState: WorldState = cast context.get("WorldState");
		final sf: EntitySF = cast data;
		final id = sf.id;

		final entity = this.make(id, worldState);
		entity.loadStruct(context, option, data);

		if (context != null) context.add(entity);
		return entity;
	}
}
