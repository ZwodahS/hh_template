package world;

class Entity extends zf.engine2.Entity {
	// ---- Aliases ---- //
	public var world(get, never): World;

	// ---- Components ---- //
	public var renderComponent(default, set): RenderComponent;

	public function set_renderComponent(rc: RenderComponent): RenderComponent {
		final prev = this.renderComponent;
		this.renderComponent = rc;
		this.renderComponent.entity = this;
		onComponentChanged(prev, this.renderComponent);
		return this.renderComponent;
	}

	inline function get_world()
		return cast this.__world__;

	// ---- Game Specific code ---- //
	public function new(id: Int = -1) {
		super(id);
	}
}
