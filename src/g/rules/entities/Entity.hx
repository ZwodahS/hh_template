package g.rules.entities;

typedef EntitySF = {
	public var id: Int;
	public var typeId: String;
	public var components: Dynamic;
};

/**
	Tue 22:42:20 26 Sep 2023 Update after Crop Rotation launched.

	This file do not need to be changed for each project, unless we have a common component that we want to add.
	Instead, we should extend this with each type of entity.
**/
class Entity extends zf.engine2.Entity implements Serialisable {
	/**
		Assign the factory to the entity

		Thu 16:30:01 27 Apr 2023
		Perhaps we should move this to zf ?
		Tue 22:42:49 26 Sep 2023
		To move this to zf, probably need to move EntityFactory to zf as well.
		Probably do this later ?
	**/
	public var factory(default, null): EntityFactory;

	/**
		When entity is created, we always assign the rules to it.
	**/
	public var rules: Rules;

	// ---- Aliases ---- //
	public var world(get, never): World;

	inline function get_world()
		return cast this.__world__;

	public var kind(default, null): EntityKind = Unknown;

	// ---- Game Specific code ---- //
	public function new(id: Int = -1, factory: EntityFactory) {
		super(id);
		this.factory = factory;
		this.rules = factory.rules;
		this.typeId = factory.typeId;
	}

	public function toStruct(context: SerialiseContext): Dynamic {
		return this.factory.toStruct(context, this);
	}

	public function loadStruct(context: SerialiseContext, data: Dynamic) {
		return this.factory.loadStruct(context, this, data);
	}

	public function collectEntities(entities: Entities<Entity>) {
		entities.add(this);
	}
}
