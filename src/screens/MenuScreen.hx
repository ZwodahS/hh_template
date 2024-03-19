package screens;

class MenuScreen extends zf.Screen {
	public function new() {
		super();

		final button = zf.ui.Button.fromColor({
			defaultColor: K.getColor(".white"),
			width: 80,
			height: 20,
			text: "Start",
			textColor: K.getColor("black.0"),
			font: A.getFont("display", 1),
		});
		this.addChild(button);
		button.setX(100).setY(50);
		button.addOnClickListener("MenuScreen", (e) -> {
			final world = new abcdefg.World(abcdefg.WorldGlobals.rules, Globals.currentProfile);
			world.worldState = abcdefg.WorldGlobals.rules.newGame();
			this.game.switchScreen(new abcdefg.GameScreen(world));
		});
	}

	override public function update(dt: Float) {}

	override public function render(engine: h3d.Engine) {}

	override public function onEvent(event: hxd.Event) {}

	override public function destroy() {}
}
