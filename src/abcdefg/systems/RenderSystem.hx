package abcdefg.systems;

class RenderSystem extends System {
	// ---- All the various layers to draw into ---- //

	/**
		A non blocking animator.

		Use this for animation that is non-blocking
	**/
	public final animator: zf.up.Updater;

	/**
		WindowRenderSystem, a sub system for rendering windows
	**/
	public final windowRenderSystem: zf.ui.WindowRenderSystem;

	/**
		TooltipRenderSystem, a sub system for rendering tooltips
	**/
	public final tooltipRenderSystem: zf.ui.WindowRenderSystem;

	/**
		Tooltip Helper to attach tooltip to any h2d.Object.

		For game entity, it is better to use tooltip component.
	**/
	public final tooltipHelper: zf.ui.TooltipHelper;

	public var drawLayers: RO_World;

	var handler: UIElement;

	public function new() {
		super();
		this.animator = new zf.up.Updater();

		// ---- Setup the main layers ---- //
		this.drawLayers = new RO_World(this);
		this.drawLayers.bgLayers.addChild(Assets.fromColor(0xff5eb0ce, Globals.game.gameWidth,
			Globals.game.gameHeight));

		// ---- Setup WindowRenderSystem ---- //
		final windowBounds = new h2d.col.Bounds();
		windowBounds.xMin = 15;
		windowBounds.yMin = 15;
		windowBounds.xMax = Globals.game.gameWidth - 15;
		windowBounds.yMax = Globals.game.gameHeight - 15;
		this.windowRenderSystem = new zf.ui.WindowRenderSystem(windowBounds, this.drawLayers.windowLayers);
		this.windowRenderSystem.defaultRenderDirection = [Down, Right, Left, Up];
		this.windowRenderSystem.defaultSpacing = 5;

		this.tooltipRenderSystem = new zf.ui.WindowRenderSystem(windowBounds, this.drawLayers.tooltipLayers);
		this.tooltipRenderSystem.defaultRenderDirection = [Down, Up, Right, Left];
		this.tooltipRenderSystem.defaultSpacing = 2;

		this.tooltipHelper = new zf.ui.TooltipHelper(this.tooltipRenderSystem);
	}

	override public function init(world: zf.engine2.World) {
		super.init(world);

		this.drawLayers.init(world);

		world.dispatcher.listen(MOnWorldStateSet.MessageType, (message: zf.Message) -> {
			handleMOnWorldStateSet(cast message);
		}, 0);
	}

	function handleMOnWorldStateSet(m: MOnWorldStateSet) {}

	override public function reset() {
		this.animator.clear();
	}

	override public function update(dt: Float) {
		super.update(dt);
		this.animator.update(dt);
	}
}
