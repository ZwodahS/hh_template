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
	}

	override public function update(dt: Float) {}

	override public function render(engine: h3d.Engine) {}

	override public function onEvent(event: hxd.Event) {}

	override public function destroy() {}
}
