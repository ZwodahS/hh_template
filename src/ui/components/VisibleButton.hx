package ui.components;

import zf.ui.Button.ObjectsButton;
import zf.ui.TooltipHelper;
import zf.ui.UIElement.TooltipShowConf;

class VisibleButtonComponent extends zf.ui.builder.Component {
	public function new() {
		super("visible-button");
	}

	override public function makeFromStruct(s: Dynamic, context: BuilderContext): h2d.Object {
		return make(zf.Access.struct(s), context);
	}

	override public function makeFromXML(element: Xml, context: BuilderContext): h2d.Object {
		return make(zf.Access.xml(element), context);
	}

	function make(conf: zf.Access, context: BuilderContext): h2d.Object {
		final component = new VisibleButton();

		try {
			final tooltipHelper: TooltipHelper = cast context.get("tooltipHelper");
			if (tooltipHelper != null) component.tooltipHelper = tooltipHelper;
		} catch (e) {}

		try {
			final tooltipConf: TooltipShowConf = cast context.get("tooltipConf");
			if (tooltipConf != null) component.tooltipShowConf = tooltipConf;
		} catch (e) {}

		return component;
	}
}

class VisibleButton extends ObjectsButton {
	/**
		0 or 1. 0 means the layer is not visible, 1 means it is.
	**/
	public var state(default, set): Int = 1;

	public function set_state(v: Int): Int {
		this.state = v;
		return this.state;
	}

	public function new() {
		super();

		zf.ui.Button.fromObjects({
			objects: [for (bm in A.res.getBitmaps("btn:hide")) bm],
		}, this);

		final window = new TooltipWindow();
		window.getTooltip = () -> {
			if (state == 1) return S.get("ui.buttons.VisibleButton.hideTooltip");
			return S.get("ui.buttons.VisibleButton.showTooltip");
		}
		this.tooltipWindow = window;

		(new zf.effects.MoveEffect({
			moveFunction: (dt: Float, pt: Point2f) -> {
				pt.x = 0;
				pt.y = Math.sin(dt / 0.5 + Math.PI) * 2;
				return pt;
			},
			duration: -1,
		})).applyTo(this);
	}
}
