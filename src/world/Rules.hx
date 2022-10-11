package world;

import world.factories.entity.EntityFactory;

class Rules {
	public var entities: Map<String, EntityFactory>;

	public function new() {
		this.entities = new Map<String, EntityFactory>();

		CompileTime.importPackage("world.factories.entity");
		final klasses = CompileTime.getAllClasses("world.factories.entity", true, world.factories.entity.EntityFactory);
		for (klass in klasses) {
			final factory: EntityFactory = cast Type.createInstance(klass, [this]);
			entities[factory.typeId] = factory;
		}
	}
}
/**
	Tue 16:08:07 11 Oct 2022

	Entities factory is how we will be handling entity creation.
	In games that have only 1 type of entity or if we are only using one class of Entity,
	we can just create more factories and Rules will automatically import them.

	There are some cases when we need to have different entity sub classes.
	In that case, the child factory cannot call super.make to handle it and will have to create the object themselves.
**/
