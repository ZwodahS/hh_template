package world.components;

/**
	Wed 21:08:40 05 Oct 2022
	We are using echo not just for the physics simulation but also for the collision detection.

	In games that we don't need the echo physics, we just need to remove EchoSystem and
	just use body.shapes for collision test

	EchoSystem will only add to the simulation if the flag is set to true.

	The reason for using this is to work with non-centered collision.
**/
class EchoComponent extends Component {
	public static final ComponentType = "EchoComponent";

	public var body: echo.Body;

	public var simulate: Bool = true;

	public function new(body: echo.Body, simulate: Bool = true) {
		this.body = body;
		this.simulate = simulate;
	}

	override public function dispose() {
		super.dispose();
		if (this.body != null) this.body.dispose();
		this.body = null;
	}
}
