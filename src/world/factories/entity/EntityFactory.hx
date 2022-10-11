package world.factories.entity;

class EntityFactory {
	public var rules: Rules;
	public var typeId: String;

	public function new(typeId: String, rules: Rules) {
		this.typeId = typeId;
		this.rules = rules;
	}

	public function make(id: Int, worldState: WorldState, conf: Dynamic = null): Entity {
		final e = new Entity(id, typeId);
		return e;
	}
}
