package screens;

class MenuScreen extends zf.Screen {
	public function new() {
		super();

		final btn = Links.getMastodonBtn();
		btn.setX(10).setY(Globals.game.gameHeight, AnchorBottom, 10);
		this.addChild(btn);

		final btn = Links.getDiscordBtn();
		btn.setX(110).setY(Globals.game.gameHeight, AnchorBottom, 10);
		this.addChild(btn);

		final btn = Links.getTwitterBtn();
		btn.setX(210).setY(Globals.game.gameHeight, AnchorBottom, 10);
		this.addChild(btn);
	}

	override public function update(dt: Float) {}

	override public function render(engine: h3d.Engine) {}

	override public function onEvent(event: hxd.Event) {}

	override public function destroy() {}
}
