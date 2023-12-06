package g.entities.factories;

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

	public function toStruct(context: SerialiseContext, entity: Entity): Dynamic {
		final components: DynamicAccess<Dynamic> = {};
		@:privateAccess for (component in entity.__components__) {
			if (Std.isOfType(component, Serialisable) == false) continue;
			final sf = cast(component, Serialisable).toStruct(context);
			components.set(component.typeId, sf);
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

	public function loadStruct(context: SerialiseContext, entity: Entity, data: Dynamic): Entity {
		final sf: EntitySF = cast data;
		final components: DynamicAccess<Dynamic> = sf.components;
		@:privateAccess for (component in entity.__components__) {
			if (component != null && Std.isOfType(component, Serialisable) == false) continue;
			final componentSF = components.get(component.typeId);
			cast(component, Serialisable).loadStruct(context, componentSF);
		}
		return entity;
	}

	public function load(context: SerialiseContext, data: Dynamic): Entity {
		final worldState: WorldState = cast context.get("WorldState");
		final sf: EntitySF = cast data;
		final id = sf.id;

		final entity = this.make(id, worldState);
		entity.loadStruct(context, data);

		if (context != null) context.add(entity);
		return entity;
	}
}
