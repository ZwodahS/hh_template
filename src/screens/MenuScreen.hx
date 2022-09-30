package screens;

class MenuScreen extends zf.Screen {
	public function new() {
		super();

		final bitmap = Assets.res.getBitmap("ball");
		this.addChild(bitmap);
		bitmap.x = 10;
		bitmap.y = 10;

		final w = new World(Globals.rules, Globals.currentProfile);
		this.addChild(w.renderSystem.drawLayers);
	}

	override public function update(dt: Float) {}

	override public function render(engine: h3d.Engine) {}

	override public function onEvent(event: hxd.Event) {}

	override public function destroy() {}
}
