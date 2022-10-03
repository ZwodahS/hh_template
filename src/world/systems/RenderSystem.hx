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
		World rendering
	**/
	public final worldLayers: h2d.Layers;

	/**
		Debug layers.
	**/
	public final worldDebugLayers: h2d.Layers;

	public static final LDebug = 100;

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
		Tooltip Helper to attach tooltip to any h2d.Object.

		For game entity, it is better to use tooltip component.
	**/
	public final tooltipHelper: zf.ui.TooltipHelper;

	public function new() {
		super();
		this.animator = new zf.up.Updater();

		// ---- Setup all the various layers ---- //
		this.drawLayers = new h2d.Layers();
		this.drawLayers.add(this.bgLayers = new h2d.Layers(), 0);
		this.drawLayers.add(this.worldLayers = new h2d.Layers(), 50);
		this.drawLayers.add(this.windowLayers = new h2d.Layers(), 100);

		this.worldLayers.add(this.worldDebugLayers = new h2d.Layers(), LDebug);

		// ---- Setup WindowRenderSystem ---- //
		final windowBounds = new h2d.col.Bounds();
		windowBounds.xMin = 15;
		windowBounds.yMin = 15;
		windowBounds.xMax = Globals.game.gameWidth - 15;
		windowBounds.yMax = Globals.game.gameHeight - 15;
		this.windowRenderSystem = new zf.ui.WindowRenderSystem(windowBounds, this.windowLayers);
		this.windowRenderSystem.defaultRenderDirection = [Down, Right, Left, Up];
		this.windowRenderSystem.defaultSpacing = 5;

		this.tooltipHelper = new zf.ui.TooltipHelper(this.windowRenderSystem);
	}

	override public function init(world: zf.engine2.World) {
		super.init(world);

		// @:listen RenderSystem MOnWorldStateSet 50
		dispatcher.listen(MOnWorldStateSet.MessageType, (message: zf.Message) -> {
			for (entity in this.world.worldState.entities) {
				onEntityAdded(entity);
			}
		}, 50);
	}

	override public function reset() {
		this.animator.clear();
		this.windowLayers.removeChildren();
		this.worldLayers.removeChildren();
	}

	override public function update(dt: Float) {
		super.update(dt);
		this.animator.update(dt);
	}

	override public function onEntityAdded(e: zf.engine2.Entity) {
		final entity: Entity = cast e;
		if (entity.render == null) return;
		entity.render.sync();
		this.worldLayers.add(entity.render.object, 0);
	}

	override public function onEntityRemoved(e: zf.engine2.Entity) {
		final entity: Entity = cast e;
		if (entity.render == null) return;
		this.worldLayers.removeChild(entity.render.object);
	}
}
