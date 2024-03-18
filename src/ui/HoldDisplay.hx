package ui;

/**
	Display anything, hold it in place until right click
**/
class HoldDisplay extends UIElement {
	var display: h2d.Object;
	var bg: h2d.Bitmap;

	public var preventClose = false;

	var button: UIElement;

	public function new(object: UIElement, bgAlpha = 0.5, allowRightClick: Bool = true) {
		super();

		// block input
		this.addChild(new Interactive(Globals.game.gameWidth, Globals.game.gameHeight));
		this.addChild(this.display = new h2d.Object());

		this.display.addChild(this.bg = A.fromColor(A.res.getColor("black.0"), Globals.game.gameWidth,
			Globals.game.gameHeight));
		this.bg.alpha = bgAlpha;

		this.display.addChild(object);

		this.display.addChild(this.interactive = new Interactive(Globals.game.gameWidth, Globals.game.gameHeight));
		this.interactive.propagateEvents = true;
		this.interactive.cursor = null;
		this.addOnKeyDownListener("HoldDisplay", (e) -> {
			if (e.keyCode == hxd.Key.ESCAPE) {
				e.propagate = false;
				close();
			}
		});
		if (allowRightClick == true) {
			this.addOnRightClickListener("HoldDisplay", (e) -> {
				close();
			});
		}
		this.addOnWheelListener("HoldDisplay", (e) -> {
			e.propagate = false;
		});
	}

	public function close() {
		if (preventClose == true) return;
		this.remove();
		this.onClose();
	}

	dynamic public function onClose() {}

	public static function holdInPlace(object: UIElement, alpha = 0.5) {
		final parent = object.parent;
		final hold = new HoldDisplay(object, alpha);
		parent.addChild(hold);
		return hold;
	}
}
