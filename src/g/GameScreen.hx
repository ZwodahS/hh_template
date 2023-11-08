package g;

class GameScreen extends zf.Screen {
	public var world: World;

	public function new(w: World) {
		super();
		this.world = w;
		this.addChild(this.world.renderSystem.drawLayers);
	}

	override public function update(dt: Float) {
		this.world.update(dt);
	}

	override public function onEvent(event: hxd.Event) {
		this.world.onEvent(event);
	}

	override public function destroy() {
		if (this.world != null) this.world.dispose();
	}
}
