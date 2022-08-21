package world.systems;

class RenderSystem extends System {
	// ---- All the various layers to draw into ---- //

	/**
		The main draw layer
	**/
	public final drawLayers: h2d.Layers;

	/**
		Background layers.
	**/
	public final bgLayers: h2d.Layers;

	/**
		Window layers, used by windowRenderSystem
	**/
	public final windowLayers: h2d.Layers;

	/**
		A non blocking animator.

		Use this for animation that is non-blocking
	**/
	public final animator: zf.up.Updater;

	/**
		WindowRenderSystem, a sub system for rendering windows
	**/
	public final windowRenderSystem: WindowRenderSystem;

	/**
		Tooltip Helper to attach tooltip to any h2d.Object.

		For game entity, it is better to use tooltip component.
	**/
	public final tooltipHelper: TooltipHelper;

	public function new() {
		this.animator = new zf.up.Updater();

		// ---- Setup all the various layers ---- //
		this.drawLayers = new h2d.Layers();
		this.drawLayers.add(this.bgLayers = new h2d.Layers(), 0);
		this.drawLayers.add(this.windowLayers = new h2d.Layers(), 100);

		// ---- Setup WindowRenderSystem ---- //
		final windowBounds = new h2d.col.Bounds();
		windowBounds.xMin = 15;
		windowBounds.yMin = 15;
		windowBounds.xMax = Globals.game.gameWidth - 15;
		windowBounds.yMax = Globals.game.gameHeight - 15;
		this.windowRenderSystem = new WindowRenderSystem(windowBounds, this.windowLayers);
		this.windowRenderSystem.defaultRenderDirection = [Down, Right, Left, Up];
		this.windowRenderSystem.defaultSpacing = 5;

		this.tooltipHelper = new TooltipHelper(this.windowRenderSystem);
	}

	override public function reset() {
		this.animator.clear();
		this.windowLayers.removeChildren();
	}
}
