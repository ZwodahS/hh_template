package ui.components;

import zf.ui.Button.ObjectsButton;
import zf.ui.TooltipHelper;
import zf.ui.UIElement.TooltipShowConf;

class GenericButtonComponent extends zf.ui.builder.Component {
	public function new() {
		super("generic-button");
	}

	override public function makeFromStruct(s: Dynamic, context: BuilderContext): h2d.Object {
		return make(zf.Access.struct(s), context);
	}

	override public function makeFromXML(element: Xml, context: BuilderContext): h2d.Object {
		return make(zf.Access.xml(element), context);
	}

	function make(conf: zf.Access, context: BuilderContext): h2d.Object {
		final width = conf.getInt("width", 100);
		final height = conf.getInt("height", 20);
		final textId = conf.getString("textId", null);
		final text = textId == null ? "" : S.get(textId, false);
		final component = new GenericButton(null, [width, height]);
		component.text = text;

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

class GenericButton extends ObjectsButton {
	public var str: String;

	public function new(textId: String, size: Point2i) {
		super();
		final objects: Array<h2d.Object> = [];
		objects.push(new ScaleGrid(Assets.res.getTile("btn:generic", 0), 6, 6, 6,
			6).setWidth(size.x).setHeight(size.y));
		objects.push(new ScaleGrid(Assets.res.getTile("btn:generic", 1), 6, 6, 6,
			6).setWidth(size.x).setHeight(size.y));
		objects.push(new ScaleGrid(Assets.res.getTile("btn:generic", 2), 6, 6, 6,
			6).setWidth(size.x).setHeight(size.y));
		objects.push(new ScaleGrid(Assets.res.getTile("btn:generic", 3), 6, 6, 6,
			6).setWidth(size.x).setHeight(size.y));
		final string = textId == null ? "" : S.get(textId);
		this.str = string;
		zf.ui.Button.fromObjects({
			objects: objects,
			font: A.getFont("display", 2),
			text: string,
		}, this);
		this.textOffset = [0, -1];
		this.addCustomCursors(Assets.res.cursors["default"], Assets.res.cursors["default_clicked"], () -> {
			// @todo
		});
	}
}
