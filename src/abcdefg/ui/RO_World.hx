package abcdefg.ui;

class RO_World extends zf.ui.builder.XmlComponent {
	@:findChild public var bgLayers: h2d.Layers;
	@:findChild public var windowLayers: h2d.Layers;
	@:findChild public var tooltipLayers: h2d.Layers;
	@:findChild public var hudLayer: h2d.Object;
	@:findChild public var blockInput: h2d.Layers;

	public var blockInputI: UIElement;

	@:exposeContext public var system: RenderSystem;

	public function new(system: RenderSystem) {
		super("abcdefg/ui/RO_World.xml");

		this.system = system;

		initContext();
		initComponent();
		this.blockInput.addChild(this.blockInputI = UIElement.makeWithInteractive([G.game.gameWidth, G.game.gameHeight]));
		this.blockInput.visible = false;
	}

	public function init(world: zf.engine2.World) {}
}
