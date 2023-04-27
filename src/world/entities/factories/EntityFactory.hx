package world.entities.factories;

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
		final components: DynamicAccess<Dynamic> = {};
		@:privateAccess for (component in entity.__components__) {
			final c: Component = cast component;
			final sf = c.toStruct(context, option);
			if (sf == null) continue;
			components.set(component.typeId, c.toStruct(context, option));
		}
		final data: EntitySF = {
			id: entity.id,
			typeId: this.typeId,
			components: components,
		};
		if (context != null) {
			context.add(entity);
		}
		return data;
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, entity: Entity,
			data: Dynamic): Entity {
		final sf: EntitySF = cast data;
		final components: DynamicAccess<Dynamic> = sf.components;
		@:privateAccess for (component in entity.__components__) {
			final componentSF = components.get(component.typeId);
			final c: Component = cast component;
			c.loadStruct(context, option, componentSF);
		}
		return entity;
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
