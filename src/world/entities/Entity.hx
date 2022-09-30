package world.entities;

class Entity extends zf.engine2.Entity {
	// ---- Aliases ---- //
	public var world(get, never): World;

	// ---- Components ---- //
	public var render(default, set): RenderComponent;

	public function set_render(component: RenderComponent): RenderComponent {
		final prev = this.render;
		this.render = component;
		this.render.entity = this;
		onComponentChanged(prev, this.render);
		return this.render;
	}

	inline function get_world()
		return cast this.__world__;

	// ---- Game Specific code ---- //
	public function new(id: Int = -1) {
		super(id);
	}
}
