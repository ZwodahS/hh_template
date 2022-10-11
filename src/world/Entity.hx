package world;

class Entity extends zf.engine2.Entity {
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

	public var echo(default, set): EchoComponent;

	public function set_echo(component: EchoComponent): EchoComponent {
		final prev = this.echo;
		this.echo = component;
		onComponentChanged(prev, this.echo);
		return this.echo;
	}

	inline function get_world()
		return cast this.__world__;

	// ---- Override x/y getter setter ---- //

	/**
		Since we are using echo, we don't want to store the x/y position
	**/
	override public function get_x(): Float {
		if (this.echo == null) return super.get_x();
		return this.echo.body.x;
	}

	override public function set_x(x: Float): Float {
		if (this.echo == null) return super.set_x(x);
		return this.echo.body.x = x;
	}

	override public function get_y(): Float {
		if (this.echo == null) return super.get_y();
		return this.echo.body.y;
	}

	override public function set_y(y: Float): Float {
		if (this.echo == null) return super.set_y(y);
		return this.echo.body.y = y;
	}

	override public function setPosition(x: Float, y: Float) {
		if (this.echo == null) return super.setPosition(x, y);
		this.echo.body.x = x;
		this.echo.body.y = y;
	}

	override public function set_rotation(r: Float): Float {
		// echo uses degrees, we will use rad instead
		super.set_rotation(r);
		if (this.echo != null) this.echo.body.rotation = r / 2 / Math.PI * 360;
		return r;
	}

	public var kind: EntityKind = Empty;

	// ---- Game Specific code ---- //
	public function new(id: Int = -1, typeId: String) {
		super(id);
		this.typeId = typeId;
	}
}
/**
	Thu 00:07:24 06 Oct 2022
	We are using echo.body to store the coordinate.
	This means that the rendering is also based on the coordinate.
	Sometimes we want to render things differently from the collision shape.
	For example, if we want to render a arrow, but only want the arrow head to collide.
	There are 2 ways to do it.

	1. Let x, y origin be the original of the arrow bitmap, then add offset_x/offset_y to the arrow head.
	2. Let x, y origin be the original of the collision arrow head, and render the arrow relative to it.

	The first way is easier to visualise, so we should always do that instead.

	Thu 13:38:22 06 Oct 2022
	In a normal game where the world is a single simulated world, entity should not be child-classed.
	There are cases that this might not be the case, like a board game where entities are split into smaller types,

	i.e. Card, Token, Board.
	In those cases, we will have a child class for each of those type, probably.
	In some cases, entity may need to be composed and rules for those will also be different.
	For example, in Dice Tribes, there are Region <>--- DieRegionGroup <>---- DieRegion

	As much as possible, we will have as little entity hierachy as possible.
	This will then allow me to have a single save method for all entity in the game.
**/
