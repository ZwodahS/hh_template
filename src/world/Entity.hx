package world;

import world.factories.EntityFactory;

typedef EntitySF = {
	public var id: Int;
	public var typeId: String;
	public var components: Dynamic;
};

class Entity extends zf.engine2.Entity implements StructSerialisable {
	public var factory: EntityFactory;

	/**
		When entity is created, we always assign the rules to it.
	**/
	public var rules: Rules;

	// ---- Aliases ---- //
	public var world(get, never): World;

	// ---- Components ---- //
	public var render(default, set): RenderComponent;

	public function set_render(component: RenderComponent): RenderComponent {
		final prev = this.render;
		this.render = component;
		onComponentChanged(prev, this.render);
		return this.render;
	}

	/**
		@configure
		Remove echo if echo system is no longer necessary
	**/
	public var echo(default, set): EchoComponent;

	public function set_echo(component: EchoComponent): EchoComponent {
		final prev = this.echo;
		this.echo = component;
		onComponentChanged(prev, this.echo);
		return this.echo;
	}

	/**
		@configure
		Remove interactive if we don't need the interactive
	**/
	public var interactive(default, set): InteractiveComponent;

	public function set_interactive(component: InteractiveComponent): InteractiveComponent {
		final prev = this.interactive;
		this.interactive = component;
		onComponentChanged(prev, this.interactive);
		return this.interactive;
	}

	inline function get_world()
		return cast this.__world__;

	public var kind(default, null): EntityKind = Unknown;

	// ---- Game Specific code ---- //
	public function new(id: Int = -1, typeId: String) {
		super(id);
		this.typeId = typeId;
	}

	public function toStruct(context: SerialiseContext, option: SerialiseOption): Dynamic {
		return this.factory.toStruct(context, option, this);
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, data: Dynamic) {
		return this.factory.loadStruct(context, option, this, data);
	}

	public function collectEntities(entities: Entities<Entity>) {
		entities.add(this);
	}
}
