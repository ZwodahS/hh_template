package ui.components;

class Overline extends UIElement {
	public var display: h2d.Object;

	public function new() {
		super();

		this.addChild(this.display = new h2d.Object());
	}
}
