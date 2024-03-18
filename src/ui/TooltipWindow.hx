package ui;

/**
	A generic tooltip window

	Uses "tooltipwindow.background" scalegrid
**/
class TooltipWindow extends UIElement {
	public var title: String;
	public var titleFont: String = "display.3";
	public var titleColor: String = "black.0";
	public var bodyColor: String = "black.0";
	public var tooltip: String;
	public var tooltipFont: String = "body.2";

	public var minWidth: Int = 0;
	public var maxWidth: Int = 550;
	public var minHeight: Null<Int> = 50;

	public var spacing(default, set): Float = 0;

	public var text: HtmlText;

	public var paddings: Array<Int> = [6, 2, 6, 2];

	public function set_spacing(f: Float): Float {
		this.spacing = f;
		if (this.text != null) this.text.lineSpacing = f;
		return f;
	}

	public function new(tooltip: String = null, title: String = null) {
		super();
		this.title = title;
		this.tooltip = tooltip;
	}

	dynamic public function getTooltip(): String {
		return this.tooltip;
	}

	dynamic public function getTitle(): String {
		return this.title;
	}

	public function refreshTooltip() {
		this.text.text = getTooltip();
	}

	override public function onShow() {
		this.removeChildren();
		var tooltipString = getTooltip();
		if (tooltipString == null) {
			this.visible = false;
			return;
		}

		final flow = G.ui.makeObjectFromXMLString('<layout-vflow spacing="10"></layout-vflow>');
		final title = this.getTitle();
		if (title != null && title != "") {
			final text = G.ui.makeObjectFromXMLString('
				<text fontName="${this.titleFont}" textColor="${this.titleColor}">${title}</text>
			');
			flow.addChild(text);
		}

		final text = G.ui.makeObjectFromXMLString('
			<text fontName="${this.tooltipFont}" textColor="${this.bodyColor}" maxWidth="${this.maxWidth - 30}">
				${tooltipString}
			</text>
		');
		flow.addChild(text);

		this.text = cast text;
		this.text.lineSpacing = this.spacing;

		/**
			Tue 12:34:42 23 Jan 2024
			Not sure how we can do better, but I do want to change "window"
			I also want to make this(tooltipWindow) probably a XML components
		**/
		final obj = G.ui.makeObjectFromStruct({
			type: "window",
			conf: {
				item: {
					type: "object",
					conf: {
						object: flow,
					}
				},
				bgFactory: A.res.gridFactories["tooltipwindow.background"],
				minWidth: this.minWidth,
				maxWidth: this.maxWidth,
				paddings: this.paddings,
			}
		});

		this.addChild(obj);
		if (this.useShowDelay == true) this.visible = false;
	}
}
