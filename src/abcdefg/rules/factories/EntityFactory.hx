package abcdefg.rules.factories;

/**
	Common EntityFactory for the project
**/
class EntityFactory extends zf.engine2.EntityFactory {
	public var rules: Rules;

	public function new(typeId: String, rules: Rules) {
		super(typeId);
		this.rules = rules;
	}

	public function make(id: Int, worldState: WorldState, conf: Dynamic = null): Entity {
		throw new zf.exceptions.NotImplemented();
	}

	/**
		Create an empty entity with just the id
	**/
	override public function loadEmpty(context: SerialiseContext, data: Dynamic): Entity {
		final worldState: WorldState = cast context.get("WorldState");
		final sf: EntitySF = cast data;
		final id = sf.id;

		final entity = this.make(id, worldState);

		if (context != null) context.add(entity);
		return entity;
	}
}
