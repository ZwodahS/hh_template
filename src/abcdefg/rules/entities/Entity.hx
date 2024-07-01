package abcdefg.rules.entities;

typedef EntitySF = {
	public var id: Int;
	public var typeId: String;
	public var components: Dynamic;
};

/**
	Tue 22:42:20 26 Sep 2023 Update after Crop Rotation launched.

	This file do not need to be changed for each project, unless we have a common component that we want to add.
	Instead, we should extend this with each type of entity.

	Mon 16:36:38 01 Jul 2024 Update after Crop Rotation 1.3.

	Rework Entity and Components slightly to allow Object Pooling for entity and components.

	Object Pool in this case is per entity type, not per entity typeid
**/
class Entity extends zf.engine2.Entity implements Serialisable {
	/**
		Assign the factory to the entity

		Thu 16:30:01 27 Apr 2023
		Perhaps we should move this to zf ?
		Tue 22:42:49 26 Sep 2023 After CR launched
		To move this to zf, probably need to move EntityFactory to zf as well.
		To move this to zf means that we need Rules to be there too.
		Tue 14:53:20 19 Mar 2024
		Note to self, don't try to move this to zf
	**/
	public var factory(default, null): EntityFactory;

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
		return this.factory.rules;
	}

	public var kind(default, null): EntityKind = Unknown;

	// ---- Game Specific code ---- //
	function new(id: Int = -1) {
		super(id);
	}

	override public function dispose() {
		super.dispose();

		this.factory = null;
		this.typeId = null;
		this.kind = Unknown;
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
